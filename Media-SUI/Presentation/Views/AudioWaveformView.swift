//
//  AudioWaveformView.swift
//  Media-SUI
//
//  Created by KsArT on 27.11.2024.
//

import SwiftUI

struct AudioWaveformView: View {
    let audioLevels: [CGFloat]
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(audioLevels, id: \.self) { level in
                AudioBarView(level: level)
            }
        }
    }
}

#Preview {
    AudioWaveformView(audioLevels: [])
}
