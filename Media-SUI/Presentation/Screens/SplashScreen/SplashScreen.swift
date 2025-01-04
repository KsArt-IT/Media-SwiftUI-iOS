//
//  SplashScreen.swift
//  Media-SUI
//
//  Created by KsArT on 04.01.2025.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isLogoVisible = false
    @State private var isProgressVisible = false
    private let time = 1.5
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 20) {
                Image(.logoApp)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240, height: 240)
                    .opacity(isLogoVisible ? 1.0 : 0.0)
                    .scaleEffect(isLogoVisible ? 1.0 : 0.2)
                    .animation(.easeOut(duration: time), value: isLogoVisible)
                Text(Constants.appName)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.blue)
                    .opacity(isLogoVisible ? 1.0 : 0.0)
                    .animation(.easeOut(duration: time).delay(0.5), value: isLogoVisible)
                
            }
            Spacer()
            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .primary))
                    .opacity(isProgressVisible ? 1.0 : 0.0)
                    .scaleEffect(1.5)
                Text("KsArT.pro")
                    .font(.caption)
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            withAnimation {
                self.isLogoVisible = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                self.isProgressVisible = true
            }
        }
    }
}

#Preview {
    SplashScreen()
}
