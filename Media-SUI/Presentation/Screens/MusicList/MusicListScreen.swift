//
//  PlayerScreen.swift
//  Media-SUI
//
//  Created by KsArT on 27.11.2024.
//

import SwiftUI

struct MusicListScreen: View {
    @StateObject var viewModel: MusicListViewModel
    @Binding var playerState: PlayerAction?
    
    var body: some View {
        VStack {
            TitleTextView("Music player")
            
            List(viewModel.tracks) { track in
                TrackView(track: track)
                    .frame(height: Constants.songHeight)
                    .swipeActions(edge: .trailing) {
                        Button {
                            withAnimation {
                                viewModel.delete(track)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            viewModel.showRename(track)
                        } label: {
                            Label("Rename", systemImage: "rectangle.and.pencil.and.ellipsis")
                        }
                        .tint(.blue)
                    }
                    .onTapGesture {
                        viewModel.select(track)
                    }
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, Constants.tiny)
        .padding(.bottom, Constants.songHeight)
        .background {
            BackgroundView(position: 1)
        }
        .alertRename(isPresented: $viewModel.isRenameVisible, name: $viewModel.name) {
            viewModel.rename()
        }
        .onChange(of: viewModel.currentTrack) { _, track in
            playerState = track != nil ? .start(track) : nil
        }
        .onChange(of: playerState) { _, event in
            viewModel.selectEvent(event)
        }
        .onAppear {
            viewModel.updateMusicSongsList()
        }
    }
}

#Preview {
    MusicListScreen(
        viewModel: MusicListViewModel(
            localRepository: LocalRepositoryPreview()
        ),
        playerState: .constant(nil)
    )
}
