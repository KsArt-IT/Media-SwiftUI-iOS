//
//  Recording.swift
//  Media-SUI
//
//  Created by KsArT on 07.01.2025.
//

import Foundation

struct FileDto: Identifiable, Hashable {
    let n: Int
    let name: String
    let url: URL
    let date: Date
    var id: URL {
        url
    }
}

extension FileDto {
    func toRecording() -> Recording {
        Recording(
            n: self.n,
            name: self.name,
            url: self.url,
            date: self.date
        )
    }
    
    func toTrack() -> Track {
        Track(
            id: self.url.absoluteString,
            name: self.name,
            duration: 0,
            artistID: "",
            artistName: "",
            artistIdstr: "",
            albumName: "",
            albumID: "",
            licenseCcurl: "",
            position: 0,
            releasedate: "",
            albumImage: "",
            audio: "",
            audiodownload: "",
            shorturl: "",
            shareurl: "",
            waveform: [],
            image: nil,
            musicinfo: "",
            localUrl: self.url
        )
    }
}
