//
//  SearchScreenViewModel.swift
//  Media-SUI
//
//  Created by KsArT on 27.12.2024.
//

import Foundation

final class SearchScreenViewModel: ObservableObject {
    private let repository: MusicRepository
    private let localRepository: LocalRepository
    
    @Published var tracksState: ReloadingState = .reload
    
    private var page = 0
    @Published var tracks: [Track] = []
    @Published var currentTrack: Track?
    private var task: Task<Void, Never>?
    private var taskDownload: Task<Void, Never>?
    
    init(repository: MusicRepository, localRepository: LocalRepository) {
        self.repository = repository
        self.localRepository = localRepository
        
//        loadTracksFirst()
    }
    
    public func download(_ track: Track) {
        guard taskDownload == nil else { return }
        
        taskDownload = Task { [weak self] in
            print("SearchScreenViewModel: \(#function) file: \(track.name)")
            await self?.setState(.loading)
            await self?.downloadTrack(track)
            self?.taskDownload = nil
        }
    }
    
    private func downloadTrack(_ track: Track) async {
        print()
        print("SearchScreenViewModel: \(#function)")
        let result = await repository.fetchTrack(url: track.audiodownload)
        
        switch result {
        case .success(let data):
            if let url = await saveTrack(name: track.name, data: data) {
                print("SearchScreenViewModel: \(#function) file: \(url)")
                await setTrack(track.copy(name: url.lastPathComponent, url: url))
            }
            await setState(.reload)
        case .failure(let error):
            await showError(error)
        }
    }
    
    private func saveTrack(name: String, data: Data) async -> URL? {
        let result = await localRepository.saveTrack(name: name, data: data)
        print("SearchScreenViewModel: \(#function)")

        switch result {
        case .success(let url):
            print("SearchScreenViewModel: \(#function) file: \(url)")
            return url
        case .failure(let error):
            print("SearchScreenViewModel: \(#function) error: \(error)")
            return nil
        }
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
        for track in tracks {
            if list.first(where: { $0.id == track.id }) == nil {
                list.append(track)
            }
        }
        self.tracks = list
    }
    
    @MainActor
    private func setTrack(_ track: Track) async {
        print("SearchScreenViewModel: \(#function)")
        guard let index = self.tracks.firstIndex(where: { $0.id == track.id }) else { return }
        self.tracks[index] = track
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
