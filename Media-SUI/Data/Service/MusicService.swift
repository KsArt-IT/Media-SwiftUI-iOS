//
//  MusicService.swift
//  Media-SUI
//
//  Created by KsArT on 30.11.2024.
//

import Foundation

protocol MusicService: AnyObject {
    func fetchData<T>(endpoint: MusicEndpoint) async -> Result<T, any Error> where T: Decodable
    func fetchData(for reques: URLRequest) async throws -> Data
}
