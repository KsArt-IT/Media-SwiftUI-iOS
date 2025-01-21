//
//  SearchScreen.swift
//  Media-SUI
//
//  Created by KsArT on 27.11.2024.
//

import SwiftUI

struct SearchScreen: View {
    @StateObject var viewModel: SearchScreenViewModel
    @Binding var selected: Track?
    
    var body: some View {
        VStack {
            TitleTextView("Music search")
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.tracks) { track in
                        TrackView(track: track)
                            .onTapGesture {
//                                print("select=\(track)")
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
        .onChange(of: viewModel.currentTrack) { _, newValue in
            selected = newValue
        }
    }
}

#Preview {
    //    SearchScreen(viewModel: SearchScreenViewModel())
}
