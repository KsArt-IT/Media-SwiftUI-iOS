//
//  ReloadingState.swift
//  Media-SUI
//
//  Created by KsArT on 28.12.2024.
//

enum ReloadingState: Equatable {
    case none
    case reload
    case loading
    case error(message: String)
}
