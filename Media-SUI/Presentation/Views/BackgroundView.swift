//
//  BackgroundView.swift
//  Media-SUI
//
//  Created by KsArT on 21.01.2025.
//

import SwiftUI

struct BackgroundView: View {
    var position: Int = 0
    
    var body: some View {
        LinearGradient(
            colors: [.first, .second, .third],
            startPoint: start(),
            endPoint: end()
        )
        .ignoresSafeArea()
    }
    
    private func start() -> UnitPoint {
        switch self.position {
        case 1: .topLeading
        case 3: .topTrailing
        default: .top
        }
    }

    private func end() -> UnitPoint {
        switch self.position {
        case 1: .bottomTrailing
        case 3: .bottomLeading
        default: .bottom
        }
    }
}

#Preview {
    BackgroundView()
}
