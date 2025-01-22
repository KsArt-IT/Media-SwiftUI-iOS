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
    
    // MARK: - Player Commands
    public func onPlayerEvent(of action: PlayerAction) {
        switch action {
        case .start(let track):
            self.start(track)
        case .play:
            self.play()
        case .pauseOrPlay:
            self.pauseOrPlay()
        case .stop:
            self.stop()
        case .backward:
            break
        case .forward:
            break
        }
    }
    
    public func start(_ track: Track?) {
        print("PlayerViewModel:\(#function)")
        self.stop()
        guard let track else { return }
        
        self.track = track
        // включить плеер
        self.play()
    }
    
    private func play() {
        print("\nPlayerViewModel:\(#function)")
        guard let track, let url = track.songUrl else { return }
        
        do {
            self.currentPlaying = url
            self.currentTime = 0
            print("PlayerViewModel:\(#function): play: \(url.absoluteString)")
            audioPlayer = try getPlayer(url)
            setState(
                currentTime: Int(self.audioPlayer?.currentTime.binade ?? 0),
                duration: self.audioPlayer?.duration.exponent ?? 0,
                playing: true
            )
            audioPlayer?.play()
        } catch {
            print("PlayerViewModel:\(#function): error play: \(error.localizedDescription)")
        }
    }
    
    private func pauseOrPlay() {
        guard audioPlayer != nil else { return }
        
        if audioPlayer?.isPlaying == true {
            audioPlayer?.pause()
        } else {
            audioPlayer?.play()
        }
        updateState(Int(audioPlayer?.currentTime.binade ?? 0), playing: audioPlayer?.isPlaying)
    }
    
    private func stop() {
        print("PlayerViewModel:\(#function)")
        audioPlayer?.stop()
        audioPlayer = nil
        currentPlaying = nil
        state = nil
    }
    
    // MARK: - Player
    private func getPlayer(_ url: URL) throws -> AVAudioPlayer {
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
    private func setState(currentTime: Int, duration: Int, playing: Bool) {
        guard let track else {
            self.state = nil
            return
        }
        
        self.state = TrackState(
            id: track.id,
            name: track.name,
            currentTime: currentTime,
            duration: duration,
            artistName: track.artistName,
            image: track.image,
            isPlaying: playing
        )
    }
    
    private func updateState(_ currentTime: Int, playing: Bool? = nil) {
        guard state != nil else { return }
        
        self.state = self.state?.copy(
            currentTime: currentTime,
            isPlaying: playing
        )
    }
}

// MARK: - Player Delegate
extension PlayerViewModel: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.stop()
        NotificationCenter.default.post(name: .playbackFinished, object: nil)
    }
}
