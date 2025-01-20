//
//  PlayerScreen.swift
//  Media-SUI
//
//  Created by KsArT on 27.11.2024.
//

import SwiftUI

struct MusicListScreen: View {
    @StateObject var viewModel: MusicListViewModel
    @Binding var selected: Track?
    
    var body: some View {
        VStack {
            TitleTextView("Music player")
            
            List(viewModel.tracks) { track in
                TrackView(track: track)
                    .onTapGesture {
                        print("select=\(track)")
                        selected = track
                    }
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
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.horizontal)
        .padding(.bottom, 70)
        .alertRename(isPresented: $viewModel.isRenameVisible, name: $viewModel.name) {
            viewModel.rename()
        }
        .onAppear {
            viewModel.updateMusicSongsList()
        }
    }
}

#Preview {
//    MusicListScreen()
}
