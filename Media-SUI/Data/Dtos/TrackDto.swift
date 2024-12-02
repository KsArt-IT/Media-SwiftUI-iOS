//
//  Result.swift
//  Media-SUI
//
//  Created by KsArT on 30.11.2024.
//

struct TrackDto: Decodable {
    let id: String
    let name: String
    let duration: Int
    let artistID: String
    let artistName: String
    let artistIdstr: String
    let albumName: String
    let albumID: String
    let licenseCcurl: String
    let position: Int
    let releasedate: String
    let albumImage: String
    let audio: String
    let audiodownload: String
    let prourl: String
    let shorturl: String
    let shareurl: String
    let waveform: Waveform
    let image: String
    let musicinfo: Musicinfo
    let audiodownloadAllowed: Bool
}
