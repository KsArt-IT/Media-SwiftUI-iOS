//
//  ExpandedBottomSheet.swift
//  Media-SUI
//
//  Created by KsArT on 30.12.2024.
//

import SwiftUI

struct ExpandedBottomSheet: View {
    @Binding var expand: Bool
    var animation: Namespace.ID
    @State private var animateContent: Bool = false
    @State private var offsetY: CGFloat = 0
    let state: TrackState?
    let action: (PlayerAction) -> Void
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ZStack {
                // Marking it as Rounded Rectangle with Device Corner Radius
                RoundedRectangle(cornerSize: animateContent ? deviceCornerRadius : CGSizeZero, style: .continuous)
                    .fill(.ultraThickMaterial)
                    .overlay {
                        RoundedRectangle(cornerSize: animateContent ? deviceCornerRadius : CGSizeZero, style: .continuous)
                            .fill(.yellow)
                            .opacity(animateContent ? 1 : 0)
                    }
                    .overlay(alignment: .top) {
                        MusicInfoView(expandSheet: $expand, animation: animation, state: state, action: action)
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
                                    cornerSize: animateContent ? Constants.cornerSizeMedium : Constants.cornerSizeSmall,
                                    style: .continuous
                                )
                            )
                    }
                    .matchedGeometryEffect(id: Constants.artGeometryEffectId, in: animation)
                    // For Square Artwork Image
//                    .frame(width: size.width - 50)
                    // For Smaller Devices the padding will be 10 and for larger devices the padding will be 30
//                    .padding(.all, size.height < 700 ? 10 : 30)
                    
                    // Player View
                    PlayerView(state: state, action: action)
                    // Moving it From Bottom
                        .offset(y: animateContent ? 0 : size.height)
                }
                .padding(.top, safeArea.top + (safeArea.bottom == 0 ? 10 : 0))
                .padding(.bottom, safeArea.bottom == 0 ? 10 : safeArea.bottom)
                .padding(.horizontal, 25)
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
                    }
                    .onEnded { value in
                        withAnimation(.easeInOut(duration: 0.35)) {
                            if offsetY > size.height * 0.15 {
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

extension View {
    var deviceCornerRadius: CGSize {
        let key = "_displayCornerRadius"
        return if let screen = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.screen,
                  let cornerRadius = screen.value(forKey: key) as? CGFloat {
            CGSizeMake(cornerRadius, cornerRadius)
        } else {
            CGSizeZero
        }
    }
}
