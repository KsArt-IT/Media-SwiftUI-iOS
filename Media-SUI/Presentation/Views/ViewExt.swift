//
//  ViewExt.swift
//  Media-SUI
//
//  Created by KsArT on 30.01.2025.
//

import SwiftUI

extension View {
    var deviceCornerRadius: CGFloat {
        let key = "_displayCornerRadius"
        return if let screen = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.screen,
                  let cornerRadius = screen.value(forKey: key) as? CGFloat {
            cornerRadius
        } else {
            0
        }
    }
}
