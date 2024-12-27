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
            
            List(viewModel.tracks) { track in
                TrackView(track: track)
            }
        }
    }
}

#Preview {
//    SearchScreen(viewModel: SearchScreenViewModel())
}
