//
//  ExpandedBottomSheet.swift
//  Media-SUI
//
//  Created by KsArT on 30.12.2024.
//

import SwiftUI

struct ExpandedBottomSheet: View {
    @Binding var expandSheet: Bool
    var animation: Namespace.ID
    @State private var animateContent: Bool = false
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ZStack {
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .overlay {
                        Rectangle()
                            .fill(.background)
                            .opacity(animateContent ? 1 : 0)
                    }
                    .overlay(alignment: .top) {
                        MusicInfoView(expandSheet: $expandSheet, animation: animation)
                        // Disabling Interaction (Since it`s not Necessary Here)
                            .allowsHitTesting(false)
                            .opacity(animateContent ? 0 : 1)
                    }
                    .matchedGeometryEffect(id: Constants.bgGeometryEffectId, in: animation)
                
                VStack(spacing: 15) {
                    Capsule()
                        .fill(.gray)
                        .frame(width: 40, height: 5)
                        .opacity(animateContent ? 1 : 0)
                    
                    // Artwork Hero View
                    GeometryReader {
                        let size = $0.size
                        let imageSize = min(size.width, size.height)
                        
                        Image(.musicImg)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: imageSize, height: imageSize)
                            .clipShape(
                                RoundedRectangle(
                                    cornerSize: expandSheet ? Constants.cornerSizeMedium : Constants.cornerSizeSmall,
                                    style: .continuous
                                )
                            )
                    }
                    .matchedGeometryEffect(id: Constants.artGeometryEffectId, in: animation)
                    // For Square Artwork Image
                    .frame(width: size.width - 50)
                    // For Smaller Devices the padding will be 10 and for larger devices the padding will be 30
                    .padding(.vertical, size.height < 700 ? 10 : 30)
                    .border(.red)
                    
                    // Player View
                    PlayerView(size)
                    // Moving it From Bottom
                        .offset(y: animateContent ? 0 : size.height)
                }
                .padding(.top, safeArea.top + (safeArea.bottom == 0 ? 10 : 0))
                .padding(.bottom, safeArea.bottom == 0 ? 10 : safeArea.bottom)
                .padding(.horizontal, 25)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .clipped()
                // For testing UI
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        expandSheet = false
                        animateContent = false
                    }
                }
            }
            .ignoresSafeArea(.container, edges: .all)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.35)) {
                animateContent = true
            }
        }
    }
    
    @ViewBuilder
    func PlayerView(_ mainSize: CGSize) -> some View {
        GeometryReader {
            let size = $0.size
            // Dynamic Spacing Using Available Height
            let spacing = size.height * 0.04
            
            // Sizing it for more compact look
            VStack(spacing: spacing) {
                VStack(spacing: spacing) {
                    HStack(alignment: .center, spacing: 15) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Look What You Made Me do")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("Taylor Swift")
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
                        Text("0:00")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                        Spacer(minLength: 0)
                        
                        Text("3:31")
                            .font(.caption)
                            .foregroundStyle(.gray)

                    }
                    
                }
                // Moving it to Top
                .frame(height: size.height / 2.5, alignment: .top)
                
                // Playback Cotrols
                HStack(spacing: size.width * 0.18) {
                    Button {
                        
                    } label: {
                        Image(systemName: "backward.fill")
                        // Dynamic Sizing for Smaller to Large iPhone
                            .font(size.height < 300 ? .title3 : .title)
                    }
                    
                    // Making Play/Pause Little Bigger
                    Button {
                        
                    } label: {
                        Image(systemName: "pause.fill")
                        // Dynamic Sizing for Smaller to Large iPhone
                            .font(size.height < 300 ? .largeTitle : .system(size: 50))
                    }
                    
                    Button {
                        
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

#Preview {
//    ExpandedBottomSheet()
}
