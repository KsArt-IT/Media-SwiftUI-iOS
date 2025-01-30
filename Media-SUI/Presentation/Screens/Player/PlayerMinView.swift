//
//  MusicInfoView.swift
//  Media-SUI
//
//  Created by KsArT on 30.12.2024.
//

import SwiftUI

struct PlayerMinView: View {
    var animation: Namespace.ID
    let state: TrackState?
    let action: (PlayerAction) -> Void
    
    var body: some View {
            // Adding Matched Geometry Effect (Hero Animation)
            GeometryReader {
                let size = $0.size
                let imageSize = min(size.width, size.height)
                
                HStack(spacing: Constants.small) {
                    ImageDataView(data: state?.image)
                        .frame(width: imageSize, height: imageSize)
                        .clipShape(
                            RoundedRectangle(
                                cornerSize: Constants.cornerSizeSmall,
                                style: .continuous
                            )
                        )
                    Text(state?.name ?? "")
                        .fontWeight(.semibold)
                        .lineLimit(1)
//                        .padding(.horizontal, Constants.medium)
                    
                    Spacer(minLength: 0)
                    
                    Button {
                        action(.pauseOrPlay)
                    } label: {
                        Image(systemName: state?.isPlaying == true ? "pause.fill" : "play.fill")
                            .font(.title2)
                    }
//                    .padding(.trailing, Constants.small)
                    Button {
                        action(.forward())
                    } label: {
                        Image(systemName: "forward.fill")
                            .font(.title2)
                    }
                }
            }
            .matchedGeometryEffect(id: Constants.artGeometryEffectId, in: animation)
    }
}
