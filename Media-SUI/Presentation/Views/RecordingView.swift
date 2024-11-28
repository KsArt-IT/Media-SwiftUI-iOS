//
//  RecordingView.swift
//  Media-SUI
//
//  Created by KsArT on 27.11.2024.
//

import SwiftUI

struct RecordingView: View {
    let recording: Recording
    let isPlaying: Bool
    
    var body: some View {
        VStack {
            Text(recording.name)
            Text(recording.date.toString())
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        .background((isPlaying ? Color.blue : Color.black).opacity(0.7))
        .cornerRadius(Constants.radius)
    }
}

#Preview {
    RecordingView(
        recording: Recording(
            id: 1,
            name: "Recording",
            url: URL.applicationDirectory,
            date: Date.now
        ),
        isPlaying: false
    )
}
