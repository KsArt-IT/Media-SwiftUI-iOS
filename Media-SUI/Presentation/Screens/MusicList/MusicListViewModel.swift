//
//  MusicListViewModel.swift
//  Media-SUI
//
//  Created by KsArT on 06.01.2025.
//

import SwiftUI

final class MusicListViewModel: ObservableObject {
    private let localRepository: LocalRepository

    @Published var tracks: [Track] = []
    @Published var isRenameVisible = false
    @Published var name = ""
    @Published private(set) var currentTrack: Track?

    private var task: Task<(), Never>?
    private var maxIndex = 0

    init(localRepository: LocalRepository) {
        self.localRepository = localRepository
    }
    
    // MARK: - Player
    public func selectEvent(_ event: PlayerAction?) {
        guard let event else { return }
        
        switch event {
        case .start(let track):
            select(track)
        case .pauseOrPlay:
            break
        case .stop:
            select(nil)
        case .skipBackward:
            break
        case .backward:
            prevTrack()
        case .forward:
            nextTrack()
        case .skipForward:
            break
        case .seekPosition(_):
            break
        case .setVolume(_):
            break
        }
    }
    
    // MARK: - Get MusicSongs
    public func updateMusicSongsList() {
        print("MusicListViewModel:\(#function)")
        guard task == nil else { return }
        
        let newTask = Task { [weak self] in
            if let tracks = await self?.getMusicSongs() {
                await self?.setMusicSongs(tracks)
            }
            self?.task = nil
        }
        self.task = newTask
    }

    private func getMusicSongs() async -> [Track]? {
        let result = await localRepository.fetchData()
        
        switch result {
        case .success(let tracks):
            return tracks
        case .failure(let error):
            await showError(error)
            return nil
        }
    }
    
    // MARK: - Select Track
    public func select(_ track: Track?) {
        guard let track else { return }
        
        self.currentTrack = track
    }
    
    private func prevTrack() {
        print("MusicListViewModel: \(#function)")
        guard let currentTrack, let index = tracks.firstIndex(where: { $0.id == currentTrack.id }) else { return }
        if index > 0 {
            select(tracks[index - 1])
        }
    }
    
    private func nextTrack() {
        print("MusicListViewModel: \(#function)")
        guard let currentTrack, let index = tracks.firstIndex(where: { $0.id == currentTrack.id }) else { return }
        if index + 1 < tracks.count {
            select(tracks[index + 1])
        }
    }
    
    // MARK: - Set Tracks
    @MainActor
    private func setMusicSongs(_ tracks: [Track]) async {
        self.tracks = tracks
    }
    
    // MARK: - Delete
    public func delete(_ track: Track) {
        Task { [weak self] in
            let result = await self?.localRepository.deleteTrack(track: track)
            
            switch result {
            case .success(_):
                await self?.deleteTrack(track)
            case .failure(let error):
                await self?.showError(error)
            case .none:
                break
            }
        }
    }
    
    @MainActor
    private func deleteTrack(_ track: Track) async {
        tracks.removeAll(where: { $0.id == track.id })
    }
    
    // MARK: - Rename
    public func showRename(_ track: Track) {
        isRenameVisible = false
        self.currentTrack = track
        self.name = track.name
        isRenameVisible = true
    }
    
    public func rename() {
        guard let currentTrack, !name.isEmpty, currentTrack.name != name else { return }
        
        Task { [weak self] in
            await self?.renameMusicSong(currentTrack, to: self?.name)
        }
    }
    
    private func renameMusicSong(_ track: Track, to newName: String?) async {
        guard let newName, let url = track.songUrl else { return }
        
        let result = await localRepository.rename(at: url, to: newName)
        
        switch result {
        case .success(let url):
            await renameTrack(track.copy(name: newName, songUrl: url))
        case .failure(let error):
            await showError(error)
        }
    }
    
    @MainActor
    private func renameTrack(_ track: Track) async {
        guard let index = tracks.firstIndex(where: { $0.id == track.id} ) else { return }
        
        tracks[index] = track
    }
    
    // MARK: - Show Errors
    @MainActor
    private func showError(_ error: Error) async {
        let message = if let error = error as? LocalError {
            error.localizedDescription
        } else {
            error.localizedDescription
        }
        print("MusicListViewModel: error: \(message)")
    }
}
