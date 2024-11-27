//
//  ContentView.swift
//  Media-SUI
//
//  Created by KsArT on 27.11.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .player
    private enum Tab: LocalizedStringKey, CaseIterable {
        case player = "Player"
        case recorder = "Record"
        case search = "Search"
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            PlayerScreen()
                .tag(Tab.player)
                .tabItem {
                    Label {
                        Text(Tab.player.rawValue)
                    } icon: {
                        Image(systemName: "play.square")
                    }
                }
            RecorderScreen()
                .tag(Tab.recorder)
                .tabItem {
                    Label {
                        Text(Tab.recorder.rawValue)
                    } icon: {
                        Image(systemName: "mic.square")
                    }
                }
            SearchScreen()
                .tag(Tab.search)
                .tabItem {
                    Label {
                        Text(Tab.search.rawValue)
                    } icon: {
                        Image(systemName: "mail.and.text.magnifyingglass")
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
