//
//  TitleTextView.swift
//  Media-SUI
//
//  Created by KsArT on 27.11.2024.
//

import SwiftUI

struct TitleTextView: View {
    @State private var show = false
    private let text: LocalizedStringResource
    
    init(_ text: LocalizedStringResource) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.title)
            .fontWeight(.bold)
            .shadow(radius: Constants.shadowRadius, x: Constants.shadowOffset, y: Constants.shadowOffset)
            .padding(.bottom, Constants.small)
            .opacity(show ? 1.0 : 0.0)
            .animation(.easeInOut(duration: 2), value: show)
            .onAppear {
                withAnimation {
                    show = true
                }
            }
    }
}

#Preview {
    TitleTextView("Title test")
}
