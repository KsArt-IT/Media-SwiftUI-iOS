//
//  TracksResponse.swift
//  Media-SUI
//
//  Created by KsArT on 30.11.2024.
//

struct TracksResponse: Decodable {
    let headers: Headers
    let results: [TrackDto]
}
