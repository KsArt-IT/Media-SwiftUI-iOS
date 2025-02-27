//
//  ContentView.swift
//  Media-SUI
//
//  Created by KsArT on 27.11.2024.
//

import SwiftUI

struct ContentView: View {
    // получим тему на устройстве
    @Environment(\.colorScheme) private var colorScheme
    // сохраним-загрузим выбранную тему
    @AppStorage("appTheme") private var appTheme = AppTheme.device
    // текущий проигрываемый трек id
    @AppStorage("currentSongId") private var currentSongId = ""
    
    @Environment(\.diManager) private var di
    @State private var selectedTab: Tab = .player

    // Animation Properties
    @State private var expandSheet: Bool = false
    @Namespace private var animation

    // выбранный трек для проигрывания
    @State private var playerState: PlayerAction?
    @StateObject var viewModel: PlayerViewModel
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MusicListScreen(viewModel: di.resolve(), playerState: $playerState)
                .tabMenu(Tab.player, icon: "play.square")
            RecorderScreen(viewModel: di.resolve(), playerState: $playerState)
                .tabMenu(Tab.recorder, icon: "mic.square")
            SearchScreen(viewModel: di.resolve(), playerState: $playerState)
                .tabMenu(Tab.search, icon: "mail.and.text.magnifyingglass")
        }
        .onChange(of: playerState) { _, event in
            viewModel.onPlayerEvent(of: event)
        }
        .onChange(of: viewModel.playerState) { _, state in
            playerState = state
        }
        .musicPlayerUI(
            expand: $expandSheet,
            animation: animation,
            state: viewModel.state,
            action: viewModel.onPlayerEvent
        )
        // Hiding Tab Bar When Aheet is Expanded
        .toolbar(expandSheet ? .hidden : .visible, for: .tabBar)
        .preferredColorScheme(appTheme.scheme(colorScheme))
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
        // изменить цвет TabView, необходимо для каждого, поэтому расположено тут
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(.ultraThickMaterial, for: .tabBar)
    }
}

#Preview {
//    ContentView()
}
