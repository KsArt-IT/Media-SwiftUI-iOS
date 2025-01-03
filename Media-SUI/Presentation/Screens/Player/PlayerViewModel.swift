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
    
    public func player(of action: PlayerAction) {
        switch action {
        case .start(let track):
            self.start(track)
        case .play:
            self.play()
        case .pause:
            self.pause()
        case .stop:
            self.stop()
        case .backward:
            break
        case .forward:
            break
        }
    }
    
    public func start(_ track: Track?) {
        self.stop()
        guard let track else { return }
        
        self.track = track
        // загрузить и включить плеер
        self.downloadAndPlay()
    }
    
    private func downloadAndPlay() {
        
    }
    
    private func play() {
        guard let track, let url = URL(string: track.audiodownload) else { return }
        
        do {
            currentPlaying = url
            print("play: \(url)")
            audioPlayer = try getPlayer(url)
            state = TrackState(
                id: track.id,
                name: track.name,
                duration: track.duration,
                artistName: track.artistName,
                image: track.image
            )
            audioPlayer?.play()
        } catch {
            print("Error: play \(error.localizedDescription)")
        }
    }
    
    private func pause() {
        audioPlayer?.pause()
    }
    
    private func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
        currentPlaying = nil
        state = nil
    }
    
    private func getPlayer(_ url: URL) throws -> AVAudioPlayer {
        let player = try AVAudioPlayer(contentsOf: url)
        player.delegate = self
        return player
    }
}

extension PlayerViewModel: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.stop()
    }
}

enum PlayerAction {
    case start(_ track: Track?)
    case play
    case pause
    case stop
    case backward
    case forward
}
