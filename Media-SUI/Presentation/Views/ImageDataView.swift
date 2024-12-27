//
//  NewsImageView.swift
//  Media-SUI
//
//  Created by KsArT on 27.12.2024.
//


import SwiftUI

struct ImageDataView: View {
    let data: Data?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: Constants.cornerSize)
                .foregroundStyle(.gray.opacity(0.3))
            if let data = data, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Image("noImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .clipped()
            }
        }
        .frame(width: Constants.smalImage, height: Constants.smalImage)
    }
}

#Preview {
    ImageDataView(data: nil)
}
