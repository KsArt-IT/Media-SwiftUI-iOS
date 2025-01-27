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
            let height = size.height / 3.2
            let playButtonSize: Double = size.height < 300 ? 30 : 60
            let playButtonEdgeSize = playButtonSize * 1.5
            
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
                    if let state {
                        Slider(
                            value: Binding(
                                get: { Double(state.currentTime) },
                                set: { action(.seekPosition($0)) }
                            ),
                            in: 0...Double(state.duration),
                            step: 1
                        )
                        .foregroundStyle(Color.white)
                    } else {
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .frame(height: 5)
                            .foregroundStyle(Color.white)
                    }
                    
                    // Timing Label View
                    HStack {
                        Text(state?.currentTime.toTime() ?? "0:00")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                        Spacer(minLength: 0)
                        
                        Text(state?.duration.toTime() ?? "0:00")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                    }
                    
                }
                // Moving it to Top
                .frame(height: height, alignment: .top)
                
                // Playback Cotrols
                HStack(spacing: size.width * 0.08) {
                    Button {
                        action(.skipBackward)
                    } label: {
                        Image(systemName: "gobackward.10")
                        // Dynamic Sizing for Smaller to Large iPhone
                            .font(size.height < 300 ? .title3 : .title)
                    }
                    
                    Button {
                        withAnimation(.bouncy) {
                            action(.backward())
                        }
                    } label: {
                        Image(systemName: "backward.fill")
                        // Dynamic Sizing for Smaller to Large iPhone
                            .font(size.height < 300 ? .title3 : .title)
                    }
                    
                    // Making Play/Pause Little Bigger
                    Button {
                        action(.pauseOrPlay)
                    } label: {
                        ZStack {
                            Circle()
                                .fill(.white.opacity(0.3))
                                .frame(width: playButtonEdgeSize, height: playButtonEdgeSize)
                            Image(systemName: state?.isPlaying == true ? "pause.circle" : "play.circle")
                            // Dynamic Sizing for Smaller to Large iPhone
                                .font(.system(size: playButtonSize))
                        }
                    }
                    
                    Button {
                        withAnimation(.bouncy) {
                            action(.forward())
                        }
                    } label: {
                        Image(systemName: "forward.fill")
                        // Dynamic Sizing for Smaller to Large iPhone
                            .font(size.height < 300 ? .title3 : .title)
                    }
                    
                    Button {
                        action(.skipForward)
                    } label: {
                        Image(systemName: "goforward.10")
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
                .frame(height: height, alignment: .bottom)
            }
        }
        .compositingGroup() // Важно для корректного наложения
    }
}
