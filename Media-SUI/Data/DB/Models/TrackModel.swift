//
//  TrackModel.swift
//  Media-SUI
//
//  Created by KsArT on 16.01.2025.
//

import Foundation
import SwiftData

@Model
final class TrackModel {
    @Attribute(.unique)
    var id: String
    var name: String
    var duration: Int
    var artistID: String
    var artistName: String
    var artistIdstr: String
    var albumName: String
    var albumID: String
    var licenseCcurl: String
    var position: Int
    var releasedate: String
    var albumImage: String
    var audio: String
    var audiodownload: String
    var shorturl: String
    var shareurl: String
    var waveform: [Int]
    var imageUrl: URL? // URL на файл картинку
    var musicinfo: String
    var songUrl: URL? // URL на файл mp3
    
    init(
        id: String,
        name: String,
        duration: Int,
        artistID: String,
        artistName: String,
        artistIdstr: String,
        albumName: String,
        albumID: String,
        licenseCcurl: String,
        position: Int,
        releasedate: String,
        albumImage: String,
        audio: String,
        audiodownload: String,
        shorturl: String,
        shareurl: String,
        waveform: [Int],
        imageUrl: URL?,
        musicinfo: String,
        songUrl: URL?
    ) {
        self.id = id
        self.name = name
        self.duration = duration
        self.artistID = artistID
        self.artistName = artistName
        self.artistIdstr = artistIdstr
        self.albumName = albumName
        self.albumID = albumID
        self.licenseCcurl = licenseCcurl
        self.position = position
        self.releasedate = releasedate
        self.albumImage = albumImage
        self.audio = audio
        self.audiodownload = audiodownload
        self.shorturl = shorturl
        self.shareurl = shareurl
        self.waveform = waveform
        self.imageUrl = imageUrl
        self.musicinfo = musicinfo
        self.songUrl = songUrl
    }
}

extension TrackModel {
    func toTrack(image: Data? = nil) -> Track {
        Track(
            id: self.id,
            name: self.name,
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
            image: image,
            musicinfo: self.musicinfo,
            imageUrl: self.imageUrl,
            songUrl: self.songUrl
        )
    }
}
