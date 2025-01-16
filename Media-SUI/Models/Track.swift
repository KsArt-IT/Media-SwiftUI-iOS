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
    let imageUrl: URL?
    let songUrl: URL?
    
    public func copy(name: String, imageUrl: URL? = nil, songUrl: URL? = nil) -> Self {
        Track(
            id: self.id,
            name: name,
            duration: self.duration,
            artistID: self.artistID,
            artistName: self.artistName,
            artistIdstr: self.artistIdstr,
            albumName: self.albumName,
            albumID: self.albumID,
            licenseCcurl: self.licenseCcurl,
            position: self.position,
            releasedate: self.releasedate,
            albumImage: self.albumImage,
            audio: self.audio,
            audiodownload: self.audiodownload,
            shorturl: self.shorturl,
            shareurl: self.shareurl,
            waveform: self.waveform,
            image: self.image,
            musicinfo: self.musicinfo,
            imageUrl: imageUrl ?? self.imageUrl,
            songUrl: songUrl ?? self.songUrl
        )
    }
}
