//
//  PlayerScreen.swift
//  Media-SUI
//
//  Created by KsArT on 02.01.2025.
//

import SwiftUI

// Модификатор для отображения музыкального плеера
struct PlayerScreenModifier: ViewModifier {
    @StateObject var viewModel: PlayerViewModel
    @Binding var expand: Bool
    var animation: Namespace.ID
    @Binding var selected: Track?
    
    func body(content: Content) -> some View {
        content
        // отображение плеера в свернутом виде
            .safeAreaInset(edge: .bottom) {
                CustomBottomSheet(
                    expand: $expand,
                    animation: animation,
                    state: viewModel.state,
                    action: viewModel.player
                )
            }
            .overlay {
                if expand {
                    // отображение плеера в развернутом виде
                    ExpandedBottomSheet(
                        expand: $expand,
                        animation: animation,
                        state: viewModel.state,
                        action: viewModel.player
                    )
                        .transition(.asymmetric(insertion: .identity, removal: .offset(y: -5)))
                }
            }
            .onChange(of: selected) {
                viewModel.start(selected)
            }
    }
}

// Расширение для удобного использования модификатора
extension View {
    func musicPlayer(
        viewModel: PlayerViewModel,
        expand: Binding<Bool>,
        animation: Namespace.ID,
        selected: Binding<Track?>
    ) -> some View {
        self.modifier(
            PlayerScreenModifier(
                viewModel: viewModel,
                expand: expand,
                animation: animation,
                selected: selected
            )
        )
    }
}
