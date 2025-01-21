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
                .frame(width: Constants.songImage, height: Constants.songImage)
                .cornerRadius(Constants.radius)
            VStack {
                Text(track.name)
                    .font(.title3)
                    .lineLimit(1)
                Text(track.albumName)
                    .font(.caption)
                    .lineLimit(1)
                Text(track.artistName)
                    .font(.subheadline)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal, Constants.small)
            Text(track.duration.toTime())
                .font(.title3)
        }
        .padding(.all, Constants.tiny)
        .overlay(
            RoundedRectangle(cornerRadius: Constants.radius)
                .stroke(false ? .yellow : .second, lineWidth: 1)
        )
        .listRowInsets(.init())
        .listRowBackground(Color.clear)
    }
}
