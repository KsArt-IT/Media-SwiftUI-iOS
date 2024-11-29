//
//  ButtonRecordingView.swift
//  Media-SUI
//
//  Created by KsArT on 27.11.2024.
//

import SwiftUI

struct ButtonRecordingView: View {
    @Binding var isRecording: Bool
    @Binding var isDisabled: Bool
    let onClick: () -> Void
    
    var body: some View {
        Button(action: {
            isDisabled = false
            provideHapticFeedback()
            onClick()
        }) {
            Circle()
                .fill(isRecording ? .red : .green)
                .overlay {
                    Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                        .font(.largeTitle)
                        .foregroundStyle(Color.white)
                }
                .shadow(
                    color: isRecording ? .red.opacity(0.75) : .green.opacity(0.75),
                    radius: 15,
                    x: 0,
                    y: 0
                )
                .scaleEffect(isRecording ? 1 : 0.8)
                .animation(.spring, value: isRecording)
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1)
        .accessibilityLabel(isRecording ? "Stop Recording" : "Start Recording")
        .accessibilityHint("Double-tap to toggle recording")
    }
    
    private func provideHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
    }
}
#Preview {
    ButtonRecordingView(isRecording: .constant(true), isDisabled: .constant(false), onClick: {})
}
