//
//  JamendoMusicServiceImpl.swift
//  Media-SUI
//
//  Created by KsArT on 30.11.2024.
//

import Foundation

final class JamendoMusicServiceImpl: MusicService {
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        
        configuration.timeoutIntervalForRequest = 240
        configuration.timeoutIntervalForResource = 240
        
        return URLSession(configuration: configuration)
    }()
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        return decoder
    }()
    
    func fetchData<T>(endpoint: MusicEndpoint) async -> Result<T, any Error> where T : Decodable {
        guard let request = endpoint.request else { return .failure(NetworkError.invalidRequest) }
        print("JamendoMusicServiceImpl: \(#function) url: \(request.url?.absoluteString ?? "")")
        
        do {
            let data = try await fetchData(for: request)
            let result: T = if T.self == Data.self, let data = data as? T {
                data
            } else {
                try decode(data)
            }
            return .success(result)
        } catch let error as MusicError {
            return .failure(error)
        } catch let error as DecodingError {
            return .failure(MusicError.decodingError(error.localizedDescription))
        } catch let error as URLError where error.code == .cancelled {
            return .failure(MusicError.cancelled)
        } catch {
//            print("JamendoMusicServiceImpl: \(#function) error: \(error.localizedDescription)")
            return .failure(MusicError.networkError(error.localizedDescription))
        }
    }
    
    // MARK: - URLRequest
    private func fetchData(for reques: URLRequest) async throws -> Data {
//        print("JamendoMusicServiceImpl: \(#function)")
        let (data, response) = try await session.data(for: reques)
        if let code = getErrorCode(for: response) {
            try getErrorMsg(code, from: data)
        }
        return data
    }
    
    // MARK: - Error handling
    private func getErrorCode(for response: URLResponse) -> Int? {
//        print("JamendoMusicServiceImpl: \(#function)")
        guard let httpResponse = response as? HTTPURLResponse else { return -1 }
        
        return 200...299 ~= httpResponse.statusCode ? nil : httpResponse.statusCode
    }
    
    private func getErrorMsg(_ code: Int, from data: Data) throws {
        let message = if let response: TracksResponse = try? decode(data) {
            "\(response.headers.code)-\(response.headers.errorMessage)"
        } else {
            ""
        }
//        print("JamendoMusicServiceImpl: \(#function) error: \(message)")
        throw NetworkError.invalidResponse(code: code, message: message)
    }
    
    // MARK: - Decode data
    private func decode<T>(_ data: Data) throws -> T where T: Decodable {
//        print("JamendoMusicServiceImpl: \(#function) \(T.self)")
        do {
            let result = try decoder.decode(T.self, from: data)
//            print("JamendoMusicServiceImpl: \(#function) result \(result)")
            return result
        } catch {
//            print("JamendoMusicServiceImpl: error: \(error)")
            throw NetworkError.decodingError(error.localizedDescription)
        }
    }
}
