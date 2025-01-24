//
//  Constants.swift
//  Media-SUI
//
//  Created by KsArT on 27.11.2024.
//

import Foundation

enum Constants {
    static let appName: String = {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
        Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ??
        "Music center"
    }()

    static let dateFormatterForFileName: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        return formatter
    }()

    static let musicDir = "MusicCenter"
    static let musicExt = "mp3"

    static let imageDir = "MusicCenter"
    static let imageExt = "jpeg"

    static let recordingDir = "RecordingMusicCenter"
    static let recordingExt = "m4a"
    static let recordingPrefix = "Recording"
    static let recordingButton: CGFloat = 120
    
    static let waveformHeight: CGFloat = 50
    static let waveformNormalize: Float = 50
    static let waveformInterval = 0.05 // 24 раза в секунду
    
    static let playerUpdateInterval: TimeInterval = 1
    static let playerSkipTime: TimeInterval = 10
    
    static let radius: CGFloat = 10
    static let cornerSize = CGSize(width: 8, height: 8)

    static let cornerSizeSmall = CGSize(width: 6, height: 6)
    static let cornerSizeMedium = CGSize(width: 16, height: 16)

    static let shadowRadius: CGFloat = 8
    static let shadowOffset: CGFloat = shadowRadius / 2
    
    static let tiny: CGFloat = 4
    static let small: CGFloat = 8
    static let medium: CGFloat = 16
    static let smalImage: CGFloat = 100
    static let songImage: CGFloat = 75
    static let songHeight: CGFloat = songImage + 2 * small
    
    static let bgGeometryEffectId = "BGVIEW"
    static let artGeometryEffectId = "ARTWORK"
}
