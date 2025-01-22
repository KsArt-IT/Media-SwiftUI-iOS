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
    let isPlaying: Bool
}

extension TrackState {
    func copy(currentTime: TimeInterval, isPlaying: Bool? = nil) -> Self {
        TrackState(
            id: self.id,
            name: self.name,
            currentTime: currentTime,
            duration: self.duration,
            artistName: self.artistName,
            image: self.image,
            isPlaying: isPlaying ?? self.isPlaying
        )
    }
}
