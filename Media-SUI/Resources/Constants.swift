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
}
