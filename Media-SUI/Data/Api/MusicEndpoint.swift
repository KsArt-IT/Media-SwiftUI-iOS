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
        request.timeoutInterval = 240
        
        return request
    }
    
    private var url: URL? {
        switch self {
        case .tracks(let offset):
            createUrl(
                path: "/tracks",
                query: [
                    Self.offsetParam: "\(offset * Self.limit)",
                    Self.limitParam: "\(Self.limit)"
                ]
            )
        case .image(let url):
            URL(string: url)
        }
    }
    
    private func createUrl(url: String = Self.baseUrl, path: String? = nil, query params: [String: String]? = nil) -> URL? {
        guard var components = URLComponents(string: url) else { return nil }
        
        if let path {
            components.path += path
        }
        
        let queryItems = [createQueryItem(key: Self.clientIdParam, value: Self.clientId),
        createQueryItem(key: Self.formatParam, value: Self.format)]
        components.queryItems = if let params {
            queryItems + params.map(createQueryItem)
        } else {
            queryItems
        }
        
        return components.url
    }
    
    private func createQueryItem(key: String, value: String) -> URLQueryItem {
        URLQueryItem(name: key, value: value)
    }
    
    // https://api.jamendo.com/v3.0/tracks?client_id=c98dd4d5&format=json&offset=0&limit=10
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
