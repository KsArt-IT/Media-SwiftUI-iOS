//
//  SearchScreen.swift
//  Media-SUI
//
//  Created by KsArT on 27.11.2024.
//

import SwiftUI

struct SearchScreen: View {
    @StateObject var viewModel: SearchScreenViewModel
    
    var body: some View {
        VStack {
            TitleTextView("Music search")
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.tracks) { track in
                        TrackView(track: track)
                    }
                    // отобразим дозагрузку
                    ReloadingView(state: $viewModel.tracksState) {
                        viewModel.loadTracksFirst()
                    }
                    .font(.title)
                    .padding()
                }
                .padding(.top, Constants.small)
                .padding(.bottom, 100)
            }
        }
    }
}

#Preview {
    //    SearchScreen(viewModel: SearchScreenViewModel())
}
