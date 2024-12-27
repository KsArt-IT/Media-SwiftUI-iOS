//
//  TrackView.swift
//  Media-SUI
//
//  Created by KsArT on 27.12.2024.
//

import SwiftUI

struct TrackView: View {
    let track: Track
    
    var body: some View {
        HStack {
            ImageDataView(data: track.image)
                .padding(.horizontal)
            VStack {
                Text(track.artistName)
                    .font(.title)
                Text(track.albumName)
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text(track.duration.toTime())
                .padding(.horizontal)
        }
        .padding(.vertical)
        .cornerRadius(Constants.radius)
        .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
        .listRowSeparator(.hidden)
    }
}

#Preview {
    TrackView(
        track: Track(
            id: "168",
            name: "J'm'e FPM",
            duration: 183,
            artistID: "1",
            artistName: "TriFace",
            artistIdstr: "TriFace",
            albumName: "Premiers Jets",
            albumID: "24",
            licenseCcurl: "",
            position: 1,
            releasedate: "2004-12-17",
            albumImage: "https:\\usercontent.jamendo.com?type=album&id=24&width=300&trackid=168",
            audio: "https:\\prod-1.storage.jamendo.com?trackid=168&format=mp31&from=DRcdmeQj2vgCVB2IIcipgg%3D%3D%7C86ejO6MyjtkFZi%2F12nabcQ%3D%3D",
            audiodownload: "https:\\prod-1.storage.jamendo.com\\download\\track\\168\\mp32",
            shorturl: "",
            shareurl: "https:\\www.jamendo.com\\track\\168",
            waveform: [],
            image: nil,
            musicinfo: ""
        )
    )
}
