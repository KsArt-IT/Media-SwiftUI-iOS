//
//  AudioRecorderError.swift
//  Media-SUI
//
//  Created by KsArT on 28.11.2024.
//

enum AudioRecorderError: Error {
    case permissionDenied
    case recordingFailed(String)
    case playbackFailed(String)
}
