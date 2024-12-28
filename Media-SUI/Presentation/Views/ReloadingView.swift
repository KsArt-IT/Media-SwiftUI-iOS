//
//  ReloadingView.swift
//  Media-SUI
//
//  Created by KsArT on 28.12.2024.
//

import SwiftUI

struct ReloadingView: View {
    @Binding var state: ReloadingState
    let reloading: () -> Void
    
    var body: some View {
        VStack {
            switch state {
            case .none:
                EmptyView()
            case .reload:
                Color.clear
                    .task {
                        reloading()
                    }
            case .loading:
                ProgressView()
                    .progressViewStyle(.circular)
            case .error(let message):
                HStack {
                    Text(message)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, maxHeight: 500)
                    Button {
                        reloading()
                    } label: {
                        Image(systemName: "arrow.clockwise.circle")
                            .font(.title)
                    }
                    .buttonStyle(.borderless)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    VStack {
        List {
            ReloadingView(state: .constant(.loading)) {}
        }
    }
}
