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

    case fetchDbError(String)
    case saveDbError(String)

    // MARK: - Description
    var localizedDescription: String {
        switch self {
        case .directoryError(let message):
            String(localized: "Directory error: \(message)")
        case .saveError(let message):
            String(localized: "File creating error: \(message)")
        case .fileError(let message):
            String(localized: "File does not exist: \(message)")

        case .fetchDbError(let message):
            String(localized: "DB track fetch error: \(message)")
        case .saveDbError(let message):
            String(localized: "DB track insert error: \(message)")
        }
    }
}
