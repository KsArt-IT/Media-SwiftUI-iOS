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
    private var taskFetch: Task<Void, Never>?
    private var taskDownload: Task<Void, Never>?
    
    init(repository: MusicRepository, localRepository: LocalRepository) {
        self.repository = repository
        self.localRepository = localRepository
    }
    
    // MARK: - Download
    public func download(_ track: Track) {
        guard taskDownload == nil, track.localUrl == nil else { return }
        
        let task = Task { [weak self] in
            print("SearchScreenViewModel: \(#function) file: \(track.name)")
            await self?.setState(.loading)
            // проверить, может файл уже был загружен
            let fileUrl: URL?
            if let url = await self?.getFileLocalUrl(track) {
                fileUrl = url
            } else {
                // загружаем
                if let data = await self?.downloadTrack(track),
                   let url = await self?.saveTrack(name: track.name, data: data) {
                    fileUrl = url
                } else {
                    fileUrl = nil
                }
            }
            if let fileUrl {
                // обновим ссылку на файл
                await self?.setTrack(track.copy(name: fileUrl.lastPathComponent, url: fileUrl))
            }
            await self?.setState(.reload)

            self?.taskDownload = nil
        }
        self.taskDownload = task
    }
    
    // MARK: - Local Tracks URL
    private func getFileLocalUrl(_ track: Track) async -> URL? {
        print("SearchScreenViewModel: \(#function) file: \(track.name)")
        let result = await localRepository.fetchTrackUrl(by: track.name)
        
        return switch result {
        case .success(let url):
            url
        case .failure(_):
            nil
        }
    }
    
    private func saveTrack(name: String, data: Data) async -> URL? {
        let result = await localRepository.saveTrack(name: name, data: data)
        print("SearchScreenViewModel: \(#function)")

        return switch result {
        case .success(let url):
            url
        case .failure(let error):
            nil
        }
    }
    
    // MARK: - Download Tracks Name
    private func downloadTrack(_ track: Track) async -> Data? {
        print("\nSearchScreenViewModel: \(#function)")
        let result = await repository.fetchTrack(url: track.audiodownload)
        
        switch result {
        case .success(let data):
            return data
        case .failure(let error):
            await showError(error)
        }
        return nil
    }
    
    public func loadTracksFirst() {
        guard taskFetch == nil else { return }
        
        print("SearchScreenViewModel: \(#function)")
        let task = Task { [weak self] in
            await self?.loadTracks()
            self?.taskFetch = nil
        }
        self.taskFetch = task
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
    
    // MARK: - Set Tracks
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
        print("SearchScreenViewModel: \(#function) file: \(track.localUrl?.absoluteString ?? "")")
        guard let index = self.tracks.firstIndex(where: { $0.id == track.id }) else { return }
        self.tracks[index] = track
        self.currentTrack = track
    }
    
    // MARK: - Set State
    @MainActor
    private func setState(_ state: ReloadingState) async {
        tracksState = state
    }
    
    // MARK: - Show Errors
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
