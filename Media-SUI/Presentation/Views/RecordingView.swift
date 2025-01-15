//
//  RecordingView.swift
//  Media-SUI
//
//  Created by KsArT on 27.11.2024.
//

import SwiftUI

struct RecordingView: View {
    let recording: Recording
    let playing: Bool
    
    var body: some View {
        VStack {
            Text("№ \(recording.n) \(recording.name)")
            Text(recording.date.toString())
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        .background((playing ? Color.blue : Color.black).opacity(0.7))
        .cornerRadius(Constants.radius)
        .listRowInsets(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
        .listRowSeparator(.hidden)
    }
}

#Preview {
    RecordingView(
        recording: Recording(
            n: 0,
            name: "Recording",
            url: URL.applicationDirectory,
            date: Date.now
        ),
        playing: false
    )
}
