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
            guard !response.results.isEmpty else {
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
            return .success(tracks)
        case .failure(let error):
            return .failure(error)
        }
    }
    
}