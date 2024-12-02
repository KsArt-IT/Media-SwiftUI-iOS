//
//  TrackDto.swift
//  Media-SUI
//
//  Created by KsArT on 02.12.2024.
//

import Foundation

struct Track: Identifiable, Hashable {
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
    let shorturl: String
    let shareurl: String
    let waveform: [Int]
    let image: Data?
    let musicinfo: String
}
