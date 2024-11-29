//
//  AudioBarView.swift
//  Media-SUI
//
//  Created by KsArT on 29.11.2024.
//

import SwiftUI

struct AudioBarView: View {
    let level: CGFloat
    
    var body: some View {
        Rectangle()
            .fill(Color.blue)
            .frame(height: level * Constants.waveformHeight)
    }
}

#Preview {
    AudioBarView(level: 0.5)
}
