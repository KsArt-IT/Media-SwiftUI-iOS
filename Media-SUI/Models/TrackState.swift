//
//  TrackState.swift
//  Media-SUI
//
//  Created by KsArT on 03.01.2025.
//

import Foundation

struct TrackState {
    let id: String
    let name: String
    let albumName: String
    let artistName: String
    let position: Int
    let releasedate: String
    let image: Data?
    let duration: TimeInterval

    let currentTime: TimeInterval
    let volume: Float
    let isPlaying: Bool
}

extension TrackState {
    func copy(currentTime: TimeInterval? = nil, volume: Float? = nil, isPlaying: Bool? = nil) -> Self {
        TrackState(
            id: self.id,
            name: self.name,
            albumName: self.albumName,
            artistName: self.artistName,
            position: self.position,
            releasedate: self.releasedate,
            image: self.image,
            duration: self.duration,

            currentTime: currentTime ?? self.currentTime,
            volume: volume ?? self.volume,
            isPlaying: isPlaying ?? self.isPlaying
        )
    }
}
