//
//  CustomBottomSheet.swift
//  Media-SUI
//
//  Created by KsArT on 30.12.2024.
//

import SwiftUI

struct CustomBottomSheet: View {
    @Binding var expand: Bool
    var animation: Namespace.ID
    let state: TrackState?
    let action: (PlayerAction) -> Void

    var body: some View {
        // Animating Sheet Background (To Look Like It`s Expanding From the Bottom)
        ZStack {
            if expand {
                Rectangle()
                    .fill(.clear)
            } else {
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .overlay {
                        MusicInfoView(expandSheet: $expand, animation: animation, state: state, action: action)
                    }
                    .matchedGeometryEffect(id: Constants.bgGeometryEffectId, in: animation)
            }
        }
        .frame(height: 70)
        // Separator Line
        .overlay(alignment: .bottom, content: {
            Rectangle()
                .fill(.gray.opacity(0.3))
                .frame(height: 1)
                .offset(y: -5)
        })
        // 49: Default Tab Bar Height
        .offset(y: -49)
    }
}

#Preview {
//    CustomBottomSheet()
}
