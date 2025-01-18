//
//  FileLocalRepository.swift
//  Media-SUI
//
//  Created by KsArT on 07.01.2025.
//

import Foundation

final class FileLocalRepository: LocalRepository {
    private let service: LocalService
    private let dataService: DataService
    
    init(service: LocalService, dataService: DataService) {
        self.service = service
        self.dataService = dataService
    }
    
    // MARK: - Recorders
    func fetchRecorders() async -> Result<[Recording], any Error> {
        let result = await service.fetchFiles(dir: Constants.recordingDir, ext: Constants.recordingExt, sortByName: false)
        return switch result {
        case .success(let recordings):
                .success(recordings.map { $0.toRecording() })
        case .failure(let error):
                .failure(error)
        }
    }
    
    func getNextRecordingUrl() async -> Result<URL, any Error> {
        let result = await service.getNextFileUrl(
            dir: Constants.recordingDir,
            ext: Constants.recordingExt,
            prefix: Constants.recordingPrefix
        )
        
        return switch result {
        case .success(let url):
                .success(url)
        case .failure(let error):
                .failure(error)
        }
    }
    
    // MARK: - Files
    func isFileExists(fileUrl: URL?)  async -> Bool {
        await service.isFileExists(fileUrl: fileUrl)
    }
    
    private func fetchFile(fileUrl: URL?) async -> Data? {
        if let fileUrl, case .success(let data) = await service.fetchFile(fileUrl: fileUrl) {
            data
        } else {
            nil
        }
    }
    
    func saveFile(dir: String, name: String, data: Data) async -> Result<URL, any Error> {
        let result = await service.saveFile(
            dir: dir,
            fileName: name,
            data: data
        )
        return switch result {
        case .success(let url):
                .success(url)
        case .failure(let error):
                .failure(error)
        }
    }
    
    func rename(at url: URL, to name: String) async -> Result<URL, any Error> {
        let result = await service.rename(at: url, to: name)
        
        return switch result {
        case .success(let url):
                .success(url)
        case .failure(let error):
                .failure(error)
        }
    }
    
    func delete(at url: URL) async -> Result<Bool, any Error> {
        let result = await service.delete(at: url)
        
        return switch result {
        case .success(_):
                .success(true)
        case .failure(let error):
                .failure(error)
        }
    }
    
    private func getFileUrl(dir: String, fileName: String) async -> URL? {
        let result = await service.getFileUrl(dir: dir, fileName: fileName)
        
        return switch result {
        case .success(let url):
            url
        case .failure(_):
            nil
        }
    }
    
    // MARK: - Database
    func fetchData() async -> Result<[Track], any Error> {
        let result = await dataService.fetchData()
        
        switch result {
        case .success(let tracksModel):
            var tracks: [Track] = []
            for trackModel in tracksModel {
                let imageUrl = await getFileUrl(
                    dir: Constants.imageDir,
                    fileName: "\(trackModel.name).\(Constants.imageExt)"
                )
                let image = await fetchFile(fileUrl: imageUrl)
                let songUrl = await getFileUrl(
                    dir: Constants.musicDir,
                    fileName: "\(trackModel.name).\(Constants.musicExt)"
                )
                print("\nFileLocalRepository:\(#function): imageUrl: \(imageUrl), songUrl: \(songUrl)\n")
                // необходимо обновить url на файлы
                tracks.append(trackModel.toTrack(image: image, imageUrl: imageUrl, songUrl: songUrl))
            }
            return .success(tracks)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func fetchData(id: String) async -> Result<Track, any Error> {
        let result = await dataService.fetchData(id: id)
        
        return switch result {
        case .success(let trackModel):
                .success(trackModel.toTrack(image: await fetchFile(fileUrl: trackModel.imageUrl)))
        case .failure(let error):
                .failure(error)
        }
    }
    
    func saveData(track: Track) async -> Result<Bool, any Error> {
        let result = await dataService.saveData(track: track.toModel())
        
        return switch result {
        case .success(_):
                .success(true)
        case .failure(let error):
                .failure(error)
        }
    }
}
