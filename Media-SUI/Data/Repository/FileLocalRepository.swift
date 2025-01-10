//
//  FileLocalRepository.swift
//  Media-SUI
//
//  Created by KsArT on 07.01.2025.
//

import Foundation

final class FileLocalRepository: LocalRepository {
    private let service: LocalService
    
    init(service: LocalService) {
        self.service = service
    }
    
    func fetchRecorders() async -> Result<[Recording], any Error> {
        let result = await service.fetchFiles(dir: Constants.recordingDir, ext: Constants.recordingExt, sortByName: false)
        switch result {
        case .success(let recordings):
            return .success(recordings.map { $0.toRecording() })
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getNextRecordingUrl() async -> Result<URL, any Error> {
        let result = await service.getNextFileUrl(
            dir: Constants.recordingDir,
            ext: Constants.recordingExt,
            prefix: Constants.recordingPrefix
        )
        
        switch result {
        case .success(let url):
            return .success(url)
        case .failure(let error):
            return .failure(error)
        }
    }

    func fetchTracks() async -> Result<[Track], any Error> {
        let result = await service.fetchFiles(dir: Constants.musicDir, ext: Constants.musicExt, sortByName: false)
        switch result {
        case .success(let recordings):
            return .success(recordings.map { $0.toTrack() })
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func saveTrack(name: String, data: Data) async -> Result<URL, any Error> {
        let result = await service.saveFile(
            dir: Constants.musicDir,
            fileName: "\(name).\(Constants.musicExt)",
            data: data
        )
        switch result {
        case .success(let url):
            return .success(url)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func rename(at url: URL, to name: String) async -> Result<URL, any Error> {
        let result = await service.rename(at: url, to: name)
        
        switch result {
        case .success(let url):
            return .success(url)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func delete(at url: URL) async -> Result<Bool, any Error> {
        let result = await service.delete(at: url)
        
        switch result {
        case .success(_):
            return .success(true)
        case .failure(let error):
            return .failure(error)
        }
    }
    
}
