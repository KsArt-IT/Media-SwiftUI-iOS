//
//  AlertRenameModifier.swift
//  Media-SUI
//
//  Created by KsArT on 29.01.2025.
//


import SwiftUI

// Модификатор для отображения Alert
struct AlertInfoTrackModifier: ViewModifier {
    @Binding var isPresented: Bool
    var track: TrackState?
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented, let track {
                VStack(spacing: 10) {
                    Text("Artist: \(track.artistName)")
                        .font(.title2)
                    
                    Divider()
                    
                    Text("Album: \(track.albumName)")
                        .font(.title3)
                    
                    Text("Track: \(track.name)")
                        .font(.headline)
                    
                    Text("Position: \(track.position)")
                        .font(.body)
                    
                    Divider()

                    Text("Date: \(track.releasedate)")
                        .font(.body)
                    
                    
                    Divider()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.opacity(0.5))
                .cornerRadius(12)
                .shadow(radius: 8)
                .transition(.scale)
                .animation(.spring(), value: isPresented)
                .onTapGesture {
                    withAnimation {
                        isPresented = false
                    }
                }
            }
        }
    }
}

// Расширение для удобного использования модификатора
extension View {
    func alertInfoTrack(
        isPresented: Binding<Bool>,
        track: TrackState?
    ) -> some View {
        self.modifier(
            AlertInfoTrackModifier(
                isPresented: isPresented,
                track: track
            )
        )
    }
}
