//
//  RecorderViewModel.swift
//  Media-SUI
//
//  Created by KsArT on 27.11.2024.
//

import Foundation
import AVFoundation

// NSObject for PlayerDelegate
final class RecorderViewModel: NSObject, ObservableObject {
    private let repository: LocalRepository
    
    @Published var recordings: [Recording] = []
    @Published var audioLevels: [CGFloat] = Array(repeating: 0.0, count: 30)
    
    private var audioRecorder: AVAudioRecorder?
    private var meterTimer: Timer?
    @Published var isRecording = false
    @Published var isRecordingButtonDisabled = false
    
    private var task: Task<(), Never>?
    
    @Published var isRenameVisible = false
    @Published var name = ""
    private var recording: Recording?
    
    @Published var currentTrack: Track?
    
    init(repository: LocalRepository) {
        self.repository = repository
    }
    
    // MARK: - Fetch Recordings
    public func fetchRecordings() {
        guard task == nil else { return }
        
        let newTask = Task { [weak self] in
            let result = await self?.repository.fetchRecorders()
            switch result {
            case .success(let list):
                await self?.setRecordings(list)
            case .failure(let error):
                print("RecorderViewModel:\(#function): fetch error = \(error.localizedDescription)")
            case .none:
                break
            }
            self?.task = nil
        }
        task = newTask
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
        //        print("RecorderViewModel:\(#function)")
        do {
            audioRecorder = try await getRecorder()
            audioRecorder?.record() // start
        } catch {
            print("RecorderViewModel:\(#function): Error: \(error.localizedDescription)")
        }
    }
    
    private func stopRecording() async {
        audioRecorder?.stop()
        audioRecorder = nil
    }
    
    @MainActor
    private func changeRecordingState() async {
        isRecording = audioRecorder != nil
        isRecordingButtonDisabled = false
        if isRecording {
            // запускать таймер на main потоке
            startMeterTimer()
        } else {
            stopMeterTimer()
        }
    }
    
    // MARK: - Recorder
    private func getRecorder() async throws -> AVAudioRecorder {
        // Запрос разрешения на микрофон
        guard await AVAudioApplication.requestRecordPermission() else { throw AudioRecorderError.permissionDenied }
        guard let url = await getNextRecordingUrl() else { throw LocalError.directoryError(Constants.recordingDir) }
        
        // инициализировать сессию
        try initAudioSession()
        // создать диктофон
        let recorder = try AVAudioRecorder(
            url: url,
            settings: getSettingsRecording()
        )
        // установить делегат
        recorder.delegate = self
        recorder.isMeteringEnabled = true
        // подготовить к записи
        recorder.prepareToRecord()
        return recorder
    }
    
    private func initAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.record, mode: .default, options: [])
        try session.setActive(true)
    }
    
    private func getNextRecordingUrl() async -> URL? {
        let result = await repository.getNextRecordingUrl()
        
        return switch result {
        case .success(let url):
            url
        case .failure(_):
            nil
        }
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
    @MainActor
    private func startMeterTimer() {
        // запускать таймер на main потоке
        meterTimer = Timer.scheduledTimer(
            withTimeInterval: Constants.waveformInterval,
            repeats: true
        ) { [weak self] _ in
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
                await self?.addAudioLevels(normalizedLevel)
            }
        }
    }
    
    private func normalizedPowerLevel(from decibels: Float) -> CGFloat {
        if decibels < -Constants.waveformNormalize {
            0.0
        } else if decibels >= 0 {
            1.0
        } else {
            CGFloat((decibels + Constants.waveformNormalize) / Constants.waveformNormalize)
        }
    }
    
    @MainActor
    private func addAudioLevels(_ level: CGFloat) {
        audioLevels.append(level)
        if audioLevels.count > 30 {
            audioLevels.removeFirst()
        }
    }
    
    // MARK: - Playing
    public func select(_ track: Recording) {
        if let songUrl = currentTrack?.songUrl, songUrl == track.url {
            return
        }
        
        currentTrack = Track(
            id: track.id.absoluteString,
            name: track.name,
            duration: 0,
            artistID: "",
            artistName: "",
            artistIdstr: "",
            albumName: "",
            albumID: "",
            licenseCcurl: "",
            position: 0,
            releasedate: "",
            albumImage: "",
            audio: "",
            audiodownload: "",
            shorturl: "",
            shareurl: "",
            waveform: [],
            image: nil,
            musicinfo: "",
            imageUrl: nil,
            songUrl: track.url
        )
    }
    
    public func cancelSelection() {
        currentTrack = nil
    }
    
    public func isSelected(_ url: URL) -> Bool {
        currentTrack?.songUrl != nil && currentTrack?.songUrl == url
    }
    
    // MARK: - Delete
    public func delete(_ url: URL) {
        Task { [weak self] in
            let result = await self?.repository.delete(at: url)
            
            switch result {
            case .success(_):
                self?.recordings.removeAll(where: { $0.url == url })
            case .failure(let error):
                print("Error: delete \(error.localizedDescription)")
            case .none:
                break
            }
        }
    }
    
    // MARK: - Rename
    public func showRename(_ recording: Recording) {
        isRenameVisible = false
        self.recording = recording
        self.name = recording.name
        isRenameVisible = true
    }
    
    public func rename() {
        Task { [weak self] in
            guard let recording = self?.recording, let name = self?.name, !name.isEmpty, recording.name != name else { return }
            
            let result = await self?.repository.rename(at: recording.url, to: name)
            
            switch result {
            case .success(let url):
                await self?.renameRecording(recording, to: name, at: url)
            case .failure(let error):
                print("Error: rename \(error.localizedDescription)")
            case .none:
                break
            }
        }
    }
    
    @MainActor
    private func renameRecording(_ recording: Recording, to newName: String, at newUrl: URL) async {
        if let index = recordings.firstIndex(of: recording) {
            recordings[index] = Recording(
                n: recording.n,
                name: newName,
                url: newUrl,
                date: recording.date
            )
        }
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
