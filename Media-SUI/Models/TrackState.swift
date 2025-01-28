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
    let currentTime: TimeInterval
    let duration: TimeInterval
    let artistName: String
    let image: Data?
    let volume: Float
    let isPlaying: Bool
}

extension TrackState {
    func copy(currentTime: TimeInterval? = nil, volume: Float? = nil, isPlaying: Bool? = nil) -> Self {
        TrackState(
            id: self.id,
            name: self.name,
            currentTime: currentTime ?? self.currentTime,
            duration: self.duration,
            artistName: self.artistName,
            image: self.image,
            volume: volume ?? self.volume,
            isPlaying: isPlaying ?? self.isPlaying
        )
    }
}
