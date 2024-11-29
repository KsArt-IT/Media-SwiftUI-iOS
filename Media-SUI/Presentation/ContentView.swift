//
//  ContentView.swift
//  Media-SUI
//
//  Created by KsArT on 27.11.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .recorder
    
    var body: some View {
        TabView(selection: $selectedTab) {
            PlayerScreen()
                .tabMenu(Tab.player, icon: "play.square")
            RecorderScreen()
                .tabMenu(Tab.recorder, icon: "mic.square")
            SearchScreen()
                .tabMenu(Tab.search, icon: "mail.and.text.magnifyingglass")
        }
    }
}

fileprivate enum Tab: LocalizedStringKey, CaseIterable {
    case player = "Player"
    case recorder = "Record"
    case search = "Search"
}

fileprivate extension View {
    func tabMenu (_ tab: Tab, icon: String) -> some View {
        self
            .tag(tab)
            .tabItem {
                Label {
                    Text(tab.rawValue)
                } icon: {
                    Image(systemName: icon)
                }
            }
        // изменить цвет TabView
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(.ultraThickMaterial, for: .tabBar)
    }
}

#Preview {
    ContentView()
}
