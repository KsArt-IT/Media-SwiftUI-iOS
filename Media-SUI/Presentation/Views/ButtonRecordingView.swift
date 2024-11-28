//
//  ButtonRecordingView.swift
//  Media-SUI
//
//  Created by KsArT on 27.11.2024.
//

import SwiftUI

struct ButtonRecordingView: View {
    let isRecording: Bool
    let isDisabled: Bool
    let onClick: () -> Void
    
    var body: some View {
        Button {
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
            
            onClick()
        } label: {
            Circle()
                .fill(isRecording ? .red : .green)
                .frame(width: 120, height: 120)
                .overlay {
                    Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                        .imageScale(.large)
                        .foregroundStyle(Color.white)
                }
                .shadow(color: .white, radius: 15, x: 0, y: 0)
                .scaleEffect(isRecording ? 1.1 : 1.0)
                .animation(.spring, value: isRecording)
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.3 : 1)
    }
}

#Preview {
    ButtonRecordingView(isRecording: true, isDisabled: false, onClick: {})
}
