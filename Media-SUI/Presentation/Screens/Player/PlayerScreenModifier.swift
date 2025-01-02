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
    @Binding var selected: Track?
    
    func body(content: Content) -> some View {
        content
        // отображение плеера в свернутом виде
            .safeAreaInset(edge: .bottom) {
                CustomBottomSheet(expandSheet: $expand, animation: animation)
            }
            .overlay {
                if expand {
                    // отображение плеера в развернутом виде
                    ExpandedBottomSheet(expand: $expand, animation: animation)
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
        selected: Binding<Track?>
    ) -> some View {
        self.modifier(
            PlayerScreenModifier(
                expand: expand,
                animation: animation,
                selected: selected
            )
        )
    }
}
