//
//  PlayerViewModel.swift
//  Media-SUI
//
//  Created by KsArT on 03.01.2025.
//

import Foundation
import AVFoundation

final class PlayerViewModel: NSObject, ObservableObject {
    
    @Published var state: TrackState?
    private var track: Track?
    private var audioPlayer: AVAudioPlayer?
    private var currentPlaying: URL?
    private var currentTime: Int = 0
    private var timer: Timer?
    
    // MARK: - Player Commands
    public func onPlayerEvent(of action: PlayerAction) {
        switch action {
        case .start(let track):
            start(track)
        case .pauseOrPlay:
            pauseOrPlay()
        case .stop:
            stop()
        case .backward:
            break
        case .forward:
            break
        case .seekPosition(let time):
            playFrom(TimeInterval(time))
        }
    }
    
    private func start(_ track: Track?) {
        print("PlayerViewModel:\(#function)")
        self.stop()
        guard let track else { return }
        
        self.track = track
        // включить плеер
        Task { [weak self] in
            await self?.play()
        }
    }
    
    private func play() async {
        print("\nPlayerViewModel:\(#function)")
        guard let track, let url = track.songUrl else { return }
        
        do {
            currentPlaying = url
            currentTime = 0
            print("PlayerViewModel:\(#function): play: \(url.absoluteString)")
            audioPlayer = try await getPlayer(url)
            await setState(
                currentTime: audioPlayer?.currentTime ?? 0,
                duration: audioPlayer?.duration ?? 0,
                playing: true
            )
            audioPlayer?.play()
        } catch {
            print("PlayerViewModel:\(#function): error play: \(error.localizedDescription)")
        }
    }
    
    private func playFrom(_ time: TimeInterval) {
        guard audioPlayer != nil, let duration = audioPlayer?.duration, 0...duration ~= time else { return }
        
        audioPlayer?.currentTime = time
        audioPlayer?.play()
        updateState()
    }
    
    private func pauseOrPlay() {
        guard audioPlayer != nil else {
            // если плеера нет, значит остановлен и нужно перезапустить
            self.start(self.track)
            return
        }
        
        if audioPlayer?.isPlaying == true {
            audioPlayer?.pause()
        } else {
            audioPlayer?.play()
        }
        updateState()
    }
    
    private func stop() {
        print("PlayerViewModel:\(#function)")
        Task { [weak self] in
            self?.audioPlayer?.stop()
            self?.audioPlayer = nil
            self?.currentPlaying = nil
            await self?.setState()
        }
    }
    
    // MARK: - Player
    private func getPlayer(_ url: URL) async throws -> AVAudioPlayer {
        print("PlayerViewModel:\(#function)")
        // инициализировать сессию
        try initAudioSession()
        // создать плеер
        let player = try AVAudioPlayer(contentsOf: url)
        // установить делегат
        player.delegate = self
        // подготовить
        player.prepareToPlay()
        return player
    }
    
    private func initAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playback, mode: .default, options: [])
        //        try session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
        try session.setActive(true)
    }
    
    // MARK: - State
    @MainActor
    private func setState(_ state: TrackState? = nil) {
        self.state = state
        
        if let isPlaying = state?.isPlaying {
            self.startOrStopTimer(isPlaying)
        }
    }
    
    private func setState(currentTime: TimeInterval, duration: TimeInterval, playing: Bool) async {
        guard let track else {
            self.state = nil
            return
        }
        
        let newState = TrackState(
            id: track.id,
            name: track.name,
            currentTime: currentTime,
            duration: duration,
            artistName: track.artistName,
            image: track.image,
            isPlaying: playing
        )
        
        await self.setState(newState)
    }
    
    private func updateState() {
        guard state != nil else { return }
        
        Task { [weak self] in
            let newState  = self?.state?.copy(
                currentTime: self?.audioPlayer?.currentTime ?? 0,
                isPlaying: self?.audioPlayer?.isPlaying
            )
            
            await self?.setState(newState)
        }
    }
    
    // MARK: - Timer update
    @MainActor
    private func startOrStopTimer(_ start: Bool?) {
        if start == true {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    @MainActor
    private func startTimer() {
        guard timer == nil else { return }
        // запускать таймер на main потоке
        timer = Timer.scheduledTimer(
            withTimeInterval: Constants.playerUpdateInterval,
            repeats: true
        ) { [weak self] _ in
            self?.updateState()
        }
    }
    
    private func stopTimer() {
        guard timer != nil else { return }
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - Player Delegate
extension PlayerViewModel: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.stop()
        NotificationCenter.default.post(name: .playbackFinished, object: nil)
    }
}
