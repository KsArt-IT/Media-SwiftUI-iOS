//
//  PlayerView.swift
//  Media-SUI
//
//  Created by KsArT on 03.01.2025.
//

import SwiftUI

struct PlayerView: View {
    let state: TrackState?
    let action: (PlayerAction) -> Void
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            // Dynamic Spacing Using Available Height
            let spacing = size.height * 0.04
            
            // Sizing it for more compact look
            VStack(spacing: spacing) {
                VStack(spacing: spacing) {
                    HStack(alignment: .center, spacing: 15) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(state?.name ?? "")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text(state?.artistName ?? "")
                                .foregroundStyle(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(.white)
                                .padding(12)
                                .background {
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                        .environment(\.colorScheme, .light)
                                }
                        }
                    }
                    
                    // Timing Indicator
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .environment(\.colorScheme, .light)
                        .frame(height: 5)
                        .padding(.top, spacing)
                    
                    // Timing Label View
                    HStack {
                        Text(state?.duration.toTime() ?? "0:00")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                        Spacer(minLength: 0)
                        
                        Text(state?.duration.toTime() ?? "0:00")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                    }
                    
                }
                // Moving it to Top
                .frame(height: size.height / 2.5, alignment: .top)
                
                // Playback Cotrols
                HStack(spacing: size.width * 0.18) {
                    Button {
                        action(.backward)
                    } label: {
                        Image(systemName: "backward.fill")
                        // Dynamic Sizing for Smaller to Large iPhone
                            .font(size.height < 300 ? .title3 : .title)
                    }
                    
                    // Making Play/Pause Little Bigger
                    Button {
                        action(.pause)
                    } label: {
                        Image(systemName: "pause.fill")
                        // Dynamic Sizing for Smaller to Large iPhone
                            .font(size.height < 300 ? .largeTitle : .system(size: 50))
                    }
                    
                    Button {
                        action(.forward)
                    } label: {
                        Image(systemName: "forward.fill")
                        // Dynamic Sizing for Smaller to Large iPhone
                            .font(size.height < 300 ? .title3 : .title)
                    }
                    
                }
                .foregroundStyle(.white)
                .frame(maxHeight: .infinity)
                
                // Volume $ Other Control
                VStack(spacing: spacing) {
                    HStack(spacing: spacing) {
                        Image(systemName: "speaker.fill")
                            .foregroundStyle(.gray)
                        
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .environment(\.colorScheme, .light)
                            .frame(height: 5)
                        
                        Image(systemName: "speaker.wave.3.fill")
                            .foregroundStyle(.gray)
                        
                    }
                    HStack(spacing: size.width * 0.18) {
                        Button {
                            
                        } label: {
                            Image(systemName: "quote.bubble")
                                .font(.title2)
                        }
                        
                        VStack(spacing: 6){
                            Button {
                                
                            } label: {
                                Image(systemName: "airpods.gen3")
                                    .font(.title2)
                            }
                            
                            Text("iJustine`s Airpods")
                                .font(.caption)
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "list.bullet")
                                .font(.title2)
                        }
                        
                    }
                    .foregroundStyle(.white)
                    .blendMode(.overlay) // Применение blend mode
                    .padding(.top, spacing)
                }
                // Moving it to bottom
                .frame(height: size.height / 2.5, alignment: .bottom)
            }
        }
        .compositingGroup() // Важно для корректного наложения
    }
}
