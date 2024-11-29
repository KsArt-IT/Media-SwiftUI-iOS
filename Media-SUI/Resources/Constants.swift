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

    static let recordingDir = "RecordingMusicCenter"
    static let recordingExt = "m4a"
    static let recordingButton: CGFloat = 120
    
    static let waveformHeight: CGFloat = 50
    static let waveformNormalize: Float = 50
    static let waveformInterval = 0.05 // 24 раза в секунду
    
    static let radius: CGFloat = 10
    
    static let shadowRadius: CGFloat = 8
    static let shadowOffset: CGFloat = shadowRadius / 2
    
    static let small: CGFloat = 8
    static let medium: CGFloat = 16
}
