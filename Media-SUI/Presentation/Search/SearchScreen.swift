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
            Text("Music search")
                .font(.title)
            Spacer()
        }
    }
}

#Preview {
//    SearchScreen(viewModel: SearchScreenViewModel())
}
