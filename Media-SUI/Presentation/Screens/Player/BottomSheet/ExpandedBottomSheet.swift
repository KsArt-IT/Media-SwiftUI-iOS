//
//  ExpandedBottomSheet.swift
//  Media-SUI
//
//  Created by KsArT on 30.12.2024.
//

import SwiftUI

struct ExpandedBottomSheet: View {
    @State private var animateContent: Bool = false
    @State private var offsetY: CGFloat = 0
    
    @Binding var expand: Bool
    var animation: Namespace.ID
    let state: TrackState?
    let action: (PlayerAction) -> Void
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            let cornerRadius = max(5, (1.0 - (offsetY / (size.height * 0.5))) * deviceCornerRadius)
            let cornerSize = CGSizeMake(cornerRadius, cornerRadius)
            
            ZStack {
                // Marking it as Rounded Rectangle with Device Corner Radius
                RoundedRectangle(cornerSize: animateContent ? cornerSize : CGSizeZero, style: .continuous)
                    .fill(.ultraThickMaterial)
                    .overlay {
                        RoundedRectangle(cornerSize: animateContent ? cornerSize : CGSizeZero, style: .continuous)
                            .fill(.yellow)
                            .blur(radius: 125)
                            .opacity(animateContent ? 1 : 0)
                    }
                //                    .overlay(alignment: .top) {
                //                        MusicInfoView(expandSheet: $expand, animation: animation, state: state, action: action)
                //                        // Disabling Interaction (Since it`s not Necessary Here)
                //                            .allowsHitTesting(false)
                //                            .opacity(animateContent ? 0 : 1)
                //                    }
                    .matchedGeometryEffect(id: Constants.bgGeometryEffectId, in: animation)
                
                VStack(spacing: 15) {
                    Capsule()
                        .fill(.gray)
                        .frame(width: 40, height: 5)
                        .opacity(animateContent ? 1 : 0)
                    // Mathing with Slide Animation
                        .offset(y: animateContent ? 0 : size.height)
                    
                    // Artwork Hero View
                    GeometryReader {
                        let size = $0.size
                        let imageSize = min(size.width, size.height)
                        
                        ImageDataView(data: state?.image)
                            .frame(width: imageSize, height: imageSize)
                            .clipShape(
                                RoundedRectangle(
                                    cornerSize: animateContent ? cornerSize : Constants.cornerSizeSmall,
                                    style: .continuous
                                )
                            )
                    }
                    .matchedGeometryEffect(id: Constants.artGeometryEffectId, in: animation)
                    // Player View
                    PlayerView(state: state, action: action)
                    // Moving it From Bottom
                        .offset(y: animateContent ? 0 : size.height)
                }
                .padding(.top, safeArea.top + (safeArea.bottom == 0 ? 10 : 0))
                .padding(.bottom, safeArea.bottom == 0 ? 10 : safeArea.bottom)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .clipped()
            }
            .contentShape(Rectangle())
            .offset(y: offsetY)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let translationY = value.translation.height
                        offsetY = (translationY > 0 ? translationY : 0)
                        if expand, offsetY > size.height * 0.85 {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                expand = false
                                animateContent = false
                            }
                        }
                    }
                    .onEnded { value in
                        withAnimation(.easeInOut(duration: 0.5)) {
                            if offsetY > size.height * 0.12 {
                                expand = false
                                animateContent = false
                            } else {
                                offsetY = .zero
                            }
                        }
                    }
            )
            .ignoresSafeArea(.container, edges: .all)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.35)) {
                animateContent = true
            }
        }
    }
    
}

#Preview {
    @Previewable @Namespace var animation
    let track = TrackPreview().tracks[0]
    
    ExpandedBottomSheet(
        expand: .constant(true),
        animation: animation,
        state: TrackState(
            id: track.id,
            name: track.name,
            albumName: track.albumName,
            artistName: track.artistName,
            position: track.position,
            releasedate: track.releasedate,
            image: track.image,
            duration: TimeInterval(track.duration),
            currentTime: 50,
            volume: 0.5,
            isPlaying: true
        ),
        action: {_ in
        }
    )
}
