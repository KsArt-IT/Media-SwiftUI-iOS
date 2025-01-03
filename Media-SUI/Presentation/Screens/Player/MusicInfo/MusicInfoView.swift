//
//  MusicInfoView.swift
//  Media-SUI
//
//  Created by KsArT on 30.12.2024.
//

import SwiftUI

struct MusicInfoView: View {
    @Binding var expandSheet: Bool
    var animation: Namespace.ID
    let state: TrackState?
    let action: (PlayerAction) -> Void

    var body: some View {
        HStack(spacing: 0) {
            // Adding Matched Geometry Effect (Hero Animation)
            ZStack {
                if !expandSheet {
                    GeometryReader {
                        let size = $0.size
                        let imageSize = min(size.width, size.height)
                        
                        ImageDataView(data: state?.image)
                            .frame(width: imageSize, height: imageSize)
                            .clipShape(
                                RoundedRectangle(
                                    cornerSize: expandSheet ? Constants.cornerSizeMedium : Constants.cornerSizeSmall,
                                    style: .continuous
                                )
                            )
                    }
                    .matchedGeometryEffect(id: Constants.artGeometryEffectId, in: animation)
                }
            }
            .frame(width: 45, height: 45)
            
            Text(state?.name ?? "")
                .fontWeight(.semibold)
                .lineLimit(1)
                .padding(.horizontal, Constants.medium)
            
            Spacer(minLength: 0)
            
            Button {
                action(.pause)
            } label: {
                Image(systemName: "pause.fill")
                    .font(.title2)
            }
            .padding(.trailing, Constants.small)
            Button {
                action(.forward)
            } label: {
                Image(systemName: "forward.fill")
                    .font(.title2)
            }
        }
        .foregroundStyle(Color.primary)
        .padding(.horizontal)
        .padding(.bottom, 5)
        .frame(height: 70)
        .contentShape(Rectangle())
        .onTapGesture {
            // Expanding Bottom Sheet
            withAnimation(.easeInOut(duration: 0.5)) {
                expandSheet = true
            }
        }
    }
}

#Preview {
//    MusicInfoView()
}
