//
//  RecorderViewModel.swift
//  Media-SUI
//
//  Created by KsArT on 27.11.2024.
//

import Foundation
import AVFoundation

final class RecorderViewModel: NSObject, ObservableObject {
    @Published var recordings: [Recording] = []
    @Published var audioLevels: [CGFloat] = Array(repeating: 20, count: 30)
    
    private var audioRecorder: AVAudioRecorder?
    private var meterTimer: Timer?
    @Published var isRecording = false
    @Published var isRecordingButtonDisabled = false
    
    
    private var audioPlayer: AVAudioPlayer?
    private var currentPlaying: URL?
    private var task: Task<(), Never>?
    
    public func isPlaying(_ url: URL) -> Bool {
        currentPlaying != nil && currentPlaying == url
    }
    
    // MARK: - Fetch
    public func fetchRecordings() {
        guard task == nil else { return }
        
        let newTask = Task { [weak self] in
            if let list = await self?.getRecordings() {
                await self?.setRecordings(list)
            }
            self?.task = nil
        }
        task = newTask
    }
    
    private func getRecordings() async -> [Recording] {
        guard let directory = try? getRecordingsDir() else { return [] }
        
        do {
            let files = try FileManager.default.contentsOfDirectory(
                at: directory,
                includingPropertiesForKeys: [.creationDateKey],
                options: .skipsHiddenFiles
            )
            let list = files
                .compactMap { url -> Recording? in
                    if url.pathExtension == Constants.recordingExt {
                        let attributes = try? FileManager.default.attributesOfItem(atPath: url.path())
                        let creationDate = attributes?[.creationDate] as? Date ?? Date.now
                        let fileName = url.lastPathComponent
                        let components = fileName.split(separator: "_")
                        let index = components.count > 1 ? Int(components[1]) ?? 0 : 0
                        
                        return Recording(
                            id: index,
                            name: url.lastPathComponent,
                            url: url,
                            date: creationDate
                        )
                    } else {
                        return nil
                    }
                }
                .sorted(by: { $0.id < $1.id })
            return list
        } catch {
            print("RecorderViewModel:\(#function): fetch error = \(error.localizedDescription)")
            return []
        }
    }
    
    // Путь для сохранения аудиофайлов
    private func getRecordingsDir() throws -> URL {
        let fileManager = FileManager.default
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent(Constants.recordingDir, conformingTo: .directory)
        print("RecorderViewModel:\(#function): path = \(directory.absoluteString)")
        
        if !fileManager.fileExists(atPath: directory.path) {
            try fileManager.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
        }
        // TODO: оповестить пользователя, что каталог для записей не создан
        return directory
    }
    
    @MainActor
    private func setRecordings(_ list: [Recording]) async {
        recordings = list
    }
    
    // MARK: - Recording
    public func startOrStopRecording() {
        isRecordingButtonDisabled = true
        Task { [weak self] in
            await self?.togleRecording()
        }
    }
    
    private func togleRecording() async {
        // сначало проверим и остановим
        if audioRecorder != nil {
            await stopRecording()
        }
        // если нужно записывать, стартуем
        if !isRecording {
            await startRecording()
        }
        await changeRecordingState()
    }
    
    private func startRecording() async {
        print("RecorderViewModel:\(#function)")
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try session.setActive(true)
            
            audioRecorder = try await getRecorder()
            audioRecorder?.record() // start
            startMeterTimer()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    private func stopRecording() async {
        audioRecorder?.stop()
        audioRecorder = nil
        stopMeterTimer()
    }
    
    @MainActor
    private func changeRecordingState() async {
        isRecording = audioRecorder != nil
        isRecordingButtonDisabled = false
    }
    
    // MARK: - Recorder
    private func getRecorder() async throws -> AVAudioRecorder {
        // Запрос разрешения на микрофон
        guard await AVAudioApplication.requestRecordPermission() else { throw AudioRecorderError.permissionDenied }

        let recorder = try AVAudioRecorder(
            url: getPathRecordingNext(),
            settings: getSettingsRecording()
        )
        recorder.delegate = self
        recorder.isMeteringEnabled = true
        return recorder
    }
    
    private func getPathRecordingNext() throws -> URL {
        let index = String(format: "%03d", recordings.endIndex + 1)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        let date = formatter.string(from: Date.now)
        let fileName = "Recording_\(index)_\(date).\(Constants.recordingExt)"
        
        let path = try getRecordingsDir().appendingPathComponent(fileName, conformingTo: .fileURL)
        print("RecorderViewModel:\(#function): path = \(path.absoluteString)")
        return path
    }
    
    private func getSettingsRecording() -> [String : Any] {
        [
            AVFormatIDKey: kAudioFormatMPEG4AAC, // Codec
            AVSampleRateKey: 44100, // Sample rate
            AVNumberOfChannelsKey: 2, // Stereo
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue // High quality
        ]
    }
    
    // MARK: - Timer
    private func startMeterTimer() {
        meterTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            self?.updateAudioLevels()
        }
    }
    
    private func stopMeterTimer() {
        meterTimer?.invalidate()
        meterTimer = nil
    }
    
    // MARK: - AudioLevels
    private func updateAudioLevels() {
        guard let recorder = audioRecorder else { return }
        Task { [weak self, recorder] in
            recorder.updateMeters()
            let averagePower = recorder.averagePower(forChannel: 0)
            if let normalizedLevel = self?.normalizedPowerLevel(from: averagePower) {
                await self?.normalized(normalizedLevel)
            }
        }
    }
    
    private func normalizedPowerLevel(from decibels: Float) -> CGFloat {
        if decibels < -80 {
            0.0
        } else if decibels >= 0 {
            1.0
        } else {
            CGFloat((decibels + 80) / 80)
        }
    }
    
    @MainActor
    private func normalized(_ level: CGFloat) {
        audioLevels.append(level)
        if audioLevels.count > 30 {
            audioLevels.removeFirst()
        }
    }
    
    // MARK: - Player
    public func playOrStop(_ url: URL) {
        if url == currentPlaying {
            stop()
        } else {
            play(url: url)
        }
    }
    
    private func play(url: URL) {
        stop()
        do {
            currentPlaying = url
            audioPlayer = try getPlayer(url)
            audioPlayer?.play()
        } catch {
            print("Error: play \(error.localizedDescription)")
        }
    }
    
    public func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
        currentPlaying = nil
    }
    
    private func getPlayer(_ url: URL) throws -> AVAudioPlayer {
        let player = try AVAudioPlayer(contentsOf: url)
        player.delegate = self
        return player
    }
    
    // MARK: - Operation
    public func delete(_ url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
            recordings.removeAll(where: { $0.url == url })
        } catch {
            print("Error: delete \(error.localizedDescription)")
        }
    }
}

// MARK: - PlayerDelegate
extension RecorderViewModel: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NotificationCenter.default.post(name: .playbackFinished, object: nil)
    }
}

// MARK: - RecorderDelegate
extension RecorderViewModel: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            fetchRecordings()
        } else {
            print("Recording was not successful.")
        }
    }
}
