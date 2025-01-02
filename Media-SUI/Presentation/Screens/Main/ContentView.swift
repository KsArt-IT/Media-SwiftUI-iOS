//
//  ContentView.swift
//  Media-SUI
//
//  Created by KsArT on 27.11.2024.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.diManager) private var di
    @State private var selectedTab: Tab = .player
    // выбранный трек для проигрывания
    @State private var selectedTrack: Track?
    // Animation Properties
    @State private var expandSheet: Bool = false
    @Namespace private var animation
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MusicListScreen()
                .tabMenu(Tab.player, icon: "play.square")
            RecorderScreen(viewModel: di.resolve())
                .tabMenu(Tab.recorder, icon: "mic.square")
            SearchScreen(viewModel: di.resolve(), selected: $selectedTrack)
                .tabMenu(Tab.search, icon: "mail.and.text.magnifyingglass")
        }
        // отображение плеера в свернутом виде
        .safeAreaInset(edge: .bottom) {
            CustomBottomSheet(expandSheet: $expandSheet, animation: animation)
        }
        .overlay {
            if expandSheet {
                // отображение плеера в развернутом виде
                ExpandedBottomSheet(expandSheet: $expandSheet, animation: animation)
                    .transition(.asymmetric(insertion: .identity, removal: .offset(y: -5)))
            }
        }
        // Hiding Tab Bar When Aheet is Expanded
        .toolbar(expandSheet ? .hidden : .visible, for: .tabBar)
    }
}

fileprivate enum Tab: LocalizedStringKey, CaseIterable {
    case player = "Player"
    case recorder = "Record"
    case search = "Search"
}

fileprivate extension View {
    @ViewBuilder
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
        // изменить цвет TabView, необходимо для кажого, поэтому расположено тут
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(.ultraThickMaterial, for: .tabBar)
    }
}

#Preview {
    ContentView()
}
