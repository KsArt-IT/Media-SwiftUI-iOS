//
//  Result.swift
//  Media-SUI
//
//  Created by KsArT on 30.11.2024.
//

import Foundation

struct TrackDto: Decodable {
    let id: String
    let name: String
    let duration: Int
    let artistID: String?
    let artistName: String
    let artistIdstr: String
    let albumName: String
    let albumID: String?
    let licenseCcurl: String
    let position: Int
    let releasedate: String
    let albumImage: String
    let audio: String
    let audiodownload: String
    let prourl: String
    let shorturl: String
    let shareurl: String
    let waveform: String?
    let image: String
    let musicinfo: Musicinfo?
    let audiodownloadAllowed: Bool
}

extension TrackDto {
    func mapToDomain(_ data: Data? = nil) -> Track {
        Track(
            id: self.id,
            name: self.name,
            duration: self.duration,
            artistID: self.artistID ?? "",
            artistName: self.artistName,
            artistIdstr: self.artistIdstr,
            albumName: self.albumName,
            albumID: self.albumID ?? "",
            licenseCcurl: self.licenseCcurl,
            position: self.position,
            releasedate: self.releasedate,
            albumImage: self.albumImage,
            audio: self.audio,
            audiodownload: self.audiodownload,
            shorturl: self.shorturl,
            shareurl: self.shareurl,
            waveform: [],
            image: data,
            musicinfo: self.musicinfo?.gender ?? "",
            localUrl: nil
        )
    }
}
// TODO: - реализовать преобразование waveform
// "waveform":"{\"peaks\":[38,1,32,11,0,37,3,22,21,1,33,7,5,41,18,36,29,37,74,40,47,59,32,59,19,33,38,14,44,36,29,59,31,35,30,43,34,21,18,0,0,0,0,0,0,0,0,0]}",
