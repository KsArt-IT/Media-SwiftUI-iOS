//
//  MusicListViewModel.swift
//  Media-SUI
//
//  Created by KsArT on 06.01.2025.
//

import SwiftUI

final class MusicListViewModel: ObservableObject {
    @Published var tracks: [Track] = []
    @Published var isRenameVisible = false
    @Published var name = ""
    private var currentTrack: Track?
    

    private var task: Task<(), Never>?
    private var maxIndex = 0
    
    // MARK: - Get MusicSongs
    public func updateMusicSongsList() {
        guard task == nil else { return }
        
        let newTask = Task { [weak self] in
            if let list = await self?.getMusicSongs() {
                await self?.setMusicSongs(list)
            }
            self?.task = nil
        }
        task = newTask
    }

    private func getMusicSongs() async -> [Track] {
        guard let directory = try? getMusicDir() else { return [] }
        
        do {
            let files = try FileManager.default.contentsOfDirectory(
                at: directory,
                includingPropertiesForKeys: [.creationDateKey],
                options: .skipsHiddenFiles
            )
            let list = files
                .compactMap { url -> Track? in
                    if url.pathExtension == Constants.recordingExt {
                        let attributes = try? FileManager.default.attributesOfItem(atPath: url.path())
                        let creationDate = attributes?[.creationDate] as? Date ?? Date.now
                        let fileName = url.lastPathComponent
                        let components = fileName.split(separator: "_")
                        let index = components.count > 1 ? Int(components[1]) ?? 0 : 0
                        if index > maxIndex {
                            maxIndex = index
                        }
                        
                        return Track(
                            id: index.description,
                            name: fileName,
                            duration: 0,
                            artistID: "",
                            artistName: "",
                            artistIdstr: "",
                            albumName: "",
                            albumID: "",
                            licenseCcurl: "",
                            position: 0,
                            releasedate: "",
                            albumImage: "",
                            audio: "",
                            audiodownload: "",
                            shorturl: "",
                            shareurl: "",
                            waveform: [],
                            image: nil,
                            musicinfo: "",
                            localUrl: url
                        )
                    } else {
                        return nil
                    }
                }
                .sorted(by: { $0.name < $1.name })
            return list
        } catch {
            print("RecorderViewModel:\(#function): fetch error = \(error.localizedDescription)")
            return []
        }
    }
    
    // Путь для сохранения аудиофайлов
    private func getMusicDir() throws -> URL {
        let fileManager = FileManager.default
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent(Constants.musicDir, conformingTo: .directory)
        
        if !fileManager.fileExists(atPath: directory.path) {
            try fileManager.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
        }
        // TODO: оповестить пользователя, что каталог для записей не создан
        return directory
    }
    
    @MainActor
    private func setMusicSongs(_ list: [Track]) async {
        self.tracks = list
    }
    
    // MARK: - Operation
    public func delete(_ url: URL?) {
        guard let url else { return }
        
        do {
            try FileManager.default.removeItem(at: url)
            tracks.removeAll(where: { $0.localUrl == url })
        } catch {
            print("Error: delete \(error.localizedDescription)")
        }
    }
    
    public func showRename(_ track: Track) {
        isRenameVisible = false
        self.currentTrack = track
        self.name = track.name
        isRenameVisible = true
    }
    
    public func rename() {
        guard let currentTrack, !name.isEmpty, currentTrack.name != name else { return }
        
        Task { [weak self] in
            await self?.renameRecording(currentTrack, to: self?.name)
        }
    }
    
    private func renameRecording(_ track: Track, to newName: String?) async {
        guard let newName else { return }
        
        if let newUrl = renameFile(at: track.localUrl, to: newName), let index = tracks.firstIndex(of: track) {
            await MainActor.run { [weak self] in
                self?.tracks[index] = track.copy(name: newName, url: newUrl)
            }
        }
    }
    
    private func renameFile(at url: URL?, to newName: String) -> URL? {
        guard let url else { return nil }
        
        let newURL = url.deletingLastPathComponent().appendingPathComponent(newName)
        
        do {
            try FileManager.default.moveItem(at: url, to: newURL)
            return newURL
        } catch {
            print("Error renaming file: \(error.localizedDescription)")
            return nil
        }
    }

}
