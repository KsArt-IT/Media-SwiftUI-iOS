//
//  LocalError.swift
//  Media-SUI
//
//  Created by KsArT on 07.01.2025.
//

import Foundation

enum LocalError: Error {
    case directoryError(String)
    
    // MARK: - Description
    var localizedDescription: String {
        switch self {
        case .directoryError(let dir):
            String(localized: "Directory error: \(dir)")
        }
    }
}
