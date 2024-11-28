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
    
    static let recordingDir = "RecordingMusicCenter"
    static let recordingExt = "m4a"
    
    static let radius: CGFloat = 10
    
    static let shadowRadius: CGFloat = 8
    static let shadowOffset: CGFloat = shadowRadius / 2
    
    static let small: CGFloat = 8
    static let medium: CGFloat = 16
}
