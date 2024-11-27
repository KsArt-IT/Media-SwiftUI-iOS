//
//  ContentView.swift
//  Media-SUI
//
//  Created by KsArT on 27.11.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "music.mic")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Music Player")
        }
        .border(.blue)
        .foregroundStyle(.red)
        .background(.green)
        .padding()
        .border(.green)
        .background(.blue)
    }
}

#Preview {
    ContentView()
}
