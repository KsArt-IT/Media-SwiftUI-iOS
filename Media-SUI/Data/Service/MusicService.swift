//
//  MusicService.swift
//  Media-SUI
//
//  Created by KsArT on 30.11.2024.
//

protocol MusicService: AnyObject {
    func fetchData<T>(endpoint: MusicEndpoint) async -> Result<T, any Error> where T: Decodable
}
