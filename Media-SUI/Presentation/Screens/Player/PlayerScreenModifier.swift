//
//  PlayerScreen.swift
//  Media-SUI
//
//  Created by KsArT on 02.01.2025.
//

import SwiftUI

// Модификатор для отображения музыкального плеера
struct PlayerScreenModifier: ViewModifier {
    @Binding var expand: Bool
    var animation: Namespace.ID
    let state: TrackState?
    let action: (PlayerAction) -> Void
    
    func body(content: Content) -> some View {
        content
        // отображение плеера в свернутом виде
            .safeAreaInset(edge: .bottom) {
                CustomBottomSheet(
                    expand: $expand,
                    animation: animation,
                    state: state,
                    action: action
                )
            }
            .overlay {
                if expand {
                    // отображение плеера в развернутом виде
                    ExpandedBottomSheet(
                        expand: $expand,
                        animation: animation,
                        state: state,
                        action: action
                    )
                    .transition(.asymmetric(insertion: .identity, removal: .offset(y: -5)))
                }
            }
    }
}

// Расширение для удобного использования модификатора
extension View {
    func musicPlayer(
        expand: Binding<Bool>,
        animation: Namespace.ID,
        state: TrackState?,
        action: @escaping (PlayerAction) -> Void
    ) -> some View {
        self.modifier(
            PlayerScreenModifier(
                expand: expand,
                animation: animation,
                state: state,
                action: action
            )
        )
    }
}
