//
//  SearchScreen.swift
//  Media-SUI
//
//  Created by KsArT on 27.11.2024.
//

import SwiftUI

struct SearchScreen: View {
    @StateObject var viewModel: SearchScreenViewModel
    @Binding var playerState: PlayerAction?
    
    var body: some View {
        VStack {
            TitleTextView("Music search")
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.tracks) { track in
                        TrackView(track: track)
                            .onTapGesture {
                                viewModel.download(track)
                            }
                    }
                    // отобразим дозагрузку
                    ReloadingView(state: $viewModel.tracksState) {
                        viewModel.loadTracksFirst()
                    }
                    .font(.title)
                    .padding()
                }
                .padding(.top, Constants.small)
                .padding(.bottom, Constants.songHeight)
            }
        }
        .background {
            BackgroundView(position: 3)
        }
        .onChange(of: viewModel.currentTrack) { _, track in
            playerState = track != nil ? .start(track) : nil
        }
    }
}

#Preview {
    //    SearchScreen(viewModel: SearchScreenViewModel())
}
