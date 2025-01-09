//
//  JamendoMusicRepositoryImpl.swift
//  Media-SUI
//
//  Created by KsArT on 02.12.2024.
//

import Foundation

final class JamendoMusicRepositoryImpl: MusicRepository {
    private let service: MusicService
    
    init(service: MusicService) {
        self.service = service
    }
    
    func fetchTracks(page: Int) async -> Result<[Track], any Error> {
        let result: Result<TracksResponse, Error> = await service.fetchData(endpoint: .tracks(page))
        switch result {
        case .success(let response):
//            print("JamendoMusicRepositoryImpl: success")
            guard !response.results.isEmpty else {
//                print("JamendoMusicRepositoryImpl: error")
                return .failure(
                    NetworkError.invalidResponse(code: response.headers.code, message: response.headers.errorMessage)
                )
            }
            var tracks: [Track] = []
            for track in response.results {
                let data: Result<Data, Error> = await service.fetchData(endpoint: .image(track.image))
                if case .success(let data) = data {
                    tracks.append(track.mapToDomain(data))
                } else {
                    tracks.append(track.mapToDomain())
                }
            }
//            print("JamendoMusicRepositoryImpl: success")
            return .success(tracks)
        case .failure(let error):
//            print("JamendoMusicRepositoryImpl: error: \(error.localizedDescription)")
            return .failure(error)
        }
    }
    
    // загрузка файлов по url
    func fetchTrack(url: String) async -> Result<Data, any Error> {
        guard let url = URL(string: url)  else { return .failure(NetworkError.networkError(url)) }
        
        let request = URLRequest(url: url)
        if let data = try? await service.fetchData(for: request) {
            return .success(data)
        }
        return .failure(NetworkError.networkError(url.absoluteString))
    }
}
