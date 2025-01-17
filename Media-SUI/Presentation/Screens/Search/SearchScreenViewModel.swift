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
    
    // MARK: - Track get and set
    public func download(_ track: Track) {
        guard taskDownload == nil, track.songUrl == nil else { return }
        
        let task = Task { [weak self] in
            print("SearchScreenViewModel: \(#function) file: \(track.name)")
            await self?.setState(.loading)
            // проверить, может файл уже был загружен или загрузить
            if let track = await self?.downloadAndSaveSong(track) {
                // обновить список и запустить плеер с выбранным треком
                await self?.setTrack(track)
            }
            await self?.setState(.reload)
            
            self?.taskDownload = nil
        }
        self.taskDownload = task
    }
    
    // MARK: - Local Tracks URL
    private func downloadAndSaveSong(_ track: Track) async -> Track? {
        // проверить есть ли данные в DB и взять от туда информацию
        if let trackLocal = await getTrackLocal(track) {
            return trackLocal
        }
        // скачиваем из интернета misic file
        if let data = await downloadTrack(track) {
            // сохраняем трек в локальную папку
            let songUrl = await saveFileLocal(
                dir: Constants.musicDir,
                name: "\(track.name).\(Constants.musicExt)",
                data: data
            )
            print("SearchScreenViewModel: \(#function) songUrl: \(String(describing: songUrl))")
            // сохраняем картинку в локальную папку
            let imageUrl = await saveFileLocal(
                dir: Constants.imageDir,
                name: "\(track.name).\(Constants.imageExt)",
                data: track.image
            )
            print("SearchScreenViewModel: \(#function) imageUrl: \(String(describing: imageUrl))")
            // обновляем ссылки на локальные картинку и файл mp3
            let track = track.copy(imageUrl: imageUrl, songUrl: songUrl)
            // сохраняем в базу данные трека
            await saveTrack(track)
            return track
        }
        return nil
    }
    
    private func getTrackLocal(_ track: Track) async -> Track? {
        print("SearchScreenViewModel: \(#function) file: \(track.name)")
        let result = await localRepository.fetchData(id: track.id)
        
        return switch result {
        case .success(let track):
            // проверим наличие локального файла
            if await localRepository.isFileExists(fileUrl: track.songUrl) {
                track.clearUrl()
            } else {
                track
            }
        case .failure(_):
            nil
        }
    }
    
    private func saveFileLocal(dir: String, name: String, data: Data?) async -> URL? {
        guard let data else { return nil }
        
        let result = await localRepository.saveFile(dir: dir, name: name, data: data)
        print("SearchScreenViewModel: \(#function)")
        
        return switch result {
        case .success(let url):
            url
        case .failure(_):
            nil
        }
    }
    
    private func saveTrack(_ track: Track) async {
        let result = await localRepository.saveData(track: track)
        print("SearchScreenViewModel: \(#function)")
        
        switch result {
        case .success(_):
            break
        case .failure(let error):
            await showError(error)
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
        print("SearchScreenViewModel: \(#function) file: \(track.songUrl?.absoluteString ?? "")")
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
