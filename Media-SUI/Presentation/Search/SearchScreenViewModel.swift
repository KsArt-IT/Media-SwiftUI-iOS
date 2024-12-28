//
//  SearchScreenViewModel.swift
//  Media-SUI
//
//  Created by KsArT on 27.12.2024.
//

import Foundation

final class SearchScreenViewModel: ObservableObject {
    private let repository: MusicRepository
    
    @Published var tracksState: ReloadingState = .none
    
    private var page = 0
    @Published var tracks: [Track] = []
    private var task: Task<Void, Never>?
    
    init(repository: MusicRepository) {
        self.repository = repository
        
        loadTracksFirst()
    }
    
    public func loadTracksFirst() {
        guard task == nil else { return }
        
        print("SearchScreenViewModel: \(#function)")
        task = Task { [weak self] in
            await self?.loadTracks()
            self?.task = nil
        }
    }
    
    private func loadTracks() async {
        await setState(.loading)
        
        let result = await repository.fetchTracks(page: page)
        switch result {
        case .success(let tracks):
            await setTracks(tracks)
            page += 1
            await setState(.reload)
        case .failure(let error):
            await showError(error)
        }
    }
    
    @MainActor
    private func setTracks(_ tracks: [Track]) async {
        print("SearchScreenViewModel: \(#function)")
        guard !tracks.isEmpty else { return }
        
        var list = self.tracks
        tracks.forEach { track in
            if list.first(where: { $0.id == track.id }) == nil {
                list.append(track)
            }
        }
        self.tracks = list
    }
    
    @MainActor
    private func setState(_ state: ReloadingState) async {
        tracksState = state
    }
    
    @MainActor
    private func showError(_ error: Error) async {
        let message = if let error = error as? NetworkError {
            error.localizedDescription
        } else {
            error.localizedDescription
        }
        await setState(.error(message: message))
        print("SearchScreenViewModel: error: \(message)")
    }
}
