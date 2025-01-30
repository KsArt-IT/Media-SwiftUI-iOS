//
//  CustomBottomSheet.swift
//  Media-SUI
//
//  Created by KsArT on 30.12.2024.
//

import SwiftUI

struct CustomBottomSheet: View {
    var expand: Bool
    var animation: Namespace.ID
    let state: TrackState?
    let action: (PlayerAction) -> Void
    
    var body: some View {
        // Animating Sheet Background (To Look Like It`s Expanding From the Bottom)
        Rectangle()
            .fill(.ultraThickMaterial)
            .overlay {
                PlayerMinView(animation: animation, state: state, action: action)
                    .foregroundStyle(Color.primary)
                    .padding(.horizontal)
                    .padding(.top, expand ? 10 : 2)
                    .padding(.bottom, 6)
}
            .matchedGeometryEffect(id: Constants.bgGeometryEffectId, in: animation)
            .frame(height: 70)
        // Separator Line
            .overlay(alignment: .bottom, content: {
                Rectangle()
                    .fill(.gray.opacity(0.3))
                    .frame(height: 1)
                    .offset(y: -2)
            })
        // 49: Default Tab Bar Height
            .offset(y: -49)
    }
}
