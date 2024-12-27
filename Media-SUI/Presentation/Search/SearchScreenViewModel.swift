//
//  SearchScreenViewModel.swift
//  Media-SUI
//
//  Created by KsArT on 27.12.2024.
//

import Foundation

final class SearchScreenViewModel: ObservableObject {
    private let repository: MusicRepository
    
    init(repository: MusicRepository) {
        self.repository = repository
    }
}
