//
//  JamendoApi.swift
//  Media-SUI
//
//  Created by KsArT on 30.11.2024.
//

import Foundation

// JamendoApi
enum MusicEndpoint {
    case tracks(Int)
    case image(String)
}

extension MusicEndpoint {
    var request: URLRequest? {
        guard let url = self.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
    
    private var url: URL? {
        switch self {
        case .tracks(let offset):
            createUrl(
                path: "/tracks",
                query: [
                    Self.offsetParam: "\(offset * Self.limit)"
                ]
            )
        case .image(let url):
            createUrl(url: url)
        }
    }
    
    private func createUrl(url: String = Self.baseUrl, path: String? = nil, query params: [String: String]? = nil) -> URL? {
        guard var components = URLComponents(string: url) else { return nil }
        
        if let path {
            components.path += path
        }
        
        components.queryItems = [createQueryItem(key: Self.clientIdParam, value: Self.clientId),
        createQueryItem(key: Self.formatParam, value: Self.format)]
        if let params {
            components.queryItems = components.queryItems! + params.map(createQueryItem)
        }
        
        return components.url
    }
    
    private func createQueryItem(key: String, value: String) -> URLQueryItem {
        URLQueryItem(name: key, value: value)
    }
    
    private static let baseUrl = "https://api.jamendo.com/v3.0"
    // Query params
    private static let clientIdParam = "client_id"
    private static let formatParam = "format"
    private static let format = "json"
    private static let offsetParam = "offset"
    private static let limitParam = "limit"
    private static let limit = 10
    
    // api key
    static let clientId = Bundle.main.object(forInfoDictionaryKey: "JAMENDO_API_CLIENT_ID") as? String ??
    "Please add your 'client_id' to the project"
    static let clientAuth = Bundle.main.object(forInfoDictionaryKey: "JAMENDO_API_CLIENT_AUTHENTICATE") as? String ??
    "Please add your 'CLIENT_AUTHENTICATE' to the project"
}
