//
//  LocalRepositoryPreview.swift
//  Media-SUI
//
//  Created by KsArT on 21.01.2025.
//

import Foundation

final class LocalRepositoryPreview: LocalRepository {
    private let tracks = TrackPreview().tracks
    
    func fetchRecorders() async -> Result<[Recording], any Error> {
        .success([])
    }
    
    func getNextRecordingUrl() async -> Result<URL, any Error> {
        .failure(LocalError.fileError(""))
    }
    
    func isFileExists(fileUrl: URL?) async -> Bool {
        true
    }
    
    func saveFile(dir: String, name: String, data: Data) async -> Result<URL, any Error> {
        .failure(LocalError.fileError(""))
    }
    
    func rename(at url: URL, to name: String) async -> Result<URL, any Error> {
        .failure(LocalError.fileError(""))
    }
    
    func delete(at url: URL) async -> Result<Bool, any Error> {
        .failure(LocalError.fileError(""))
    }
    
    func deleteTrack(track: Track) async -> Result<Bool, any Error> {
        .failure(LocalError.fileError(""))
    }
    
    func fetchData() async -> Result<[Track], any Error> {
        .success(tracks)
    }
    
    func fetchData(id: String) async -> Result<Track, any Error> {
        .success(tracks[0])
    }
    
    func saveData(track: Track) async -> Result<Bool, any Error> {
        .success(true)
    }
}
