//
//  MusicError.swift
//  Media-SUI
//
//  Created by KsArT on 30.11.2024.
//

enum MusicError: Error {
    case decodingError(String)
    case networkError(String)
    case cancelled
}
