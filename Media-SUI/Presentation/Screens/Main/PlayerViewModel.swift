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
    @Published var playerState: PlayerAction?
    private var track: Track?
    private var audioPlayer: AVAudioPlayer?
    private var currentPlaying: URL?
    private var volume: Float = 1.0
    private var timer: Timer?
    
    // MARK: - Player Commands
    public func onPlayerEvent(of action: PlayerAction?) {
        guard let action else { return }
        
        switch action {
        case .start(let track):
            start(track)
        case .pauseOrPlay:
            pauseOrPlay()
        case .stop:
            stop()
        case .skipBackward:
            skipBackwardAndPlay()
        case .skipForward:
            skipForwardAndPlay()
        case .backward:
            backward()
        case .forward:
            forward()
        case .seekPosition(let time):
            playFrom(TimeInterval(time))
        case .setVolume(let volume):
            setVolume(volume)
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
            print("PlayerViewModel:\(#function): play: \(url.absoluteString)")
            audioPlayer = try await getPlayer(url)
            if let audioPlayer {
                await setState(
                    currentTime: audioPlayer.currentTime,
                    duration: audioPlayer.duration,
                    volume: audioPlayer.volume,
                    playing: true
                )
            }
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
    
    private func skipBackwardAndPlay() {
        guard let audioPlayer else { return }
        
        let time = audioPlayer.currentTime - Constants.playerSkipTime
        audioPlayer.currentTime = max(0, time)
        audioPlayer.play()
        updateState()
    }
    
    private func skipForwardAndPlay() {
        guard let audioPlayer else { return }
        
        let time = audioPlayer.currentTime + Constants.playerSkipTime
        audioPlayer.currentTime = min(time, audioPlayer.duration)
        audioPlayer.play()
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
    
    private func backward() {
        print("PlayerViewModel:\(#function)")
        playerState = .backward(Int.random(in: 0..<Int.max))
    }
    
    private func forward() {
        print("PlayerViewModel:\(#function)")
        playerState = .forward(Int.random(in: 0..<Int.max))
    }
    
    private func stop() {
        print("PlayerViewModel:\(#function)")
        audioPlayer?.stop()
        audioPlayer = nil
        currentPlaying = nil
        updateState()
    }
    
    // MARK: - Volume
    private func setVolume(_ volume: Float) {
        print("PlayerViewModel:\(#function)")
        self.volume = volume
        audioPlayer?.volume = volume
        updateState()
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
        player.volume = self.volume
        return player
    }
    
    private func initAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playback, mode: .default, options: [])
        //        try session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
        try session.setActive(true)
    }
    
    // MARK: - State
    private func setState(currentTime: TimeInterval, duration: TimeInterval, volume: Float, playing: Bool) async {
        guard let track else { return }
        
        let newState = TrackState(
            id: track.id,
            name: track.name,
            albumName: track.albumName,
            artistName: track.artistName,
            position: track.position,
            releasedate: track.releasedate,
            image: track.image,
            duration: duration,
            currentTime: currentTime,
            volume: volume,
            isPlaying: playing
        )
        
        await self.setState(newState)
    }
    
    private func updateState() {
        guard state != nil else { return }

        print("PlayerViewModel:\(#function)")
        Task { [weak self] in
            let newState  = self?.state?.copy(
                currentTime: self?.audioPlayer?.currentTime ?? 0,
                volume: self?.audioPlayer?.volume ?? self?.volume,
                isPlaying: self?.audioPlayer?.isPlaying ?? false
            )
            
            await self?.setState(newState)
        }
    }
    
    @MainActor
    private func setState(_ state: TrackState?) {
        self.state = state
        
        if let isPlaying = state?.isPlaying {
            self.startOrStopTimer(isPlaying)
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
        print("PlayerViewModel:\(#function)")
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
