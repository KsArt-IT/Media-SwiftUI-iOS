//
//  LocalError.swift
//  Media-SUI
//
//  Created by KsArT on 07.01.2025.
//

import Foundation

enum LocalError: Error {
    case directoryError(String)
    case saveError(String)
    case fileError(String)
    
    // MARK: - Description
    var localizedDescription: String {
        switch self {
        case .directoryError(let dir):
            String(localized: "Directory error: \(dir)")
        case .saveError(let file):
            String(localized: "File creating error: \(file)")
        case .fileError(let file):
            String(localized: "File does not exist: \(file)")
        }
    }
}
