//
//  SearchScreenViewModel.swift
//  Media-SUI
//
//  Created by KsArT on 27.12.2024.
//

import Foundation

final class SearchScreenViewModel: ObservableObject {
    private let repository: MusicRepository
    
    private var page = 0
    @Published var tracks: [Track] = []
    private var task: Task<Void, Never>?
    
    init(repository: MusicRepository) {
        self.repository = repository
        
        loadTracks()
    }
    
    private func loadTracks() {
        guard task == nil else { return }
        
        print("SearchScreenViewModel: \(#function)")
        task = Task {
            let result = await repository.fetchTracks(page: page)
            switch result {
            case .success(let tracks):
                await setTracks(tracks)
                page += 1
            case .failure(let error):
                await showError(error)
            }
        }
    }
    
    @MainActor
    private func setTracks(_ tracks: [Track]) {
        print("SearchScreenViewModel: \(#function)")
        self.tracks += tracks
    }
    
    @MainActor
    private func showError(_ error: Error) {
        let message = if let error = error as? NetworkError {
            error.localizedDescription
        } else {
            error.localizedDescription
        }
        print("SearchScreenViewModel: error: \(message)")
    }
}
