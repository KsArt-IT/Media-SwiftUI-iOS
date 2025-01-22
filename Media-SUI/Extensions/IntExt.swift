//
//  IntExt.swift
//  Media-SUI
//
//  Created by KsArT on 27.12.2024.
//

import Foundation

extension Int {
    func toTime() -> String {
        switch self {
        case ...0:
            "0:00"
        case 1..<3600:
            String(format: "%d:%02d", self / 60, self % 60)
        case 3600...:
            String(format: "%d:%02d:%02d", self / 3600, (self % 3600) / 60, self % 60)
        default:
            ""
        }
    }
}

extension TimeInterval {
    func toTime() -> String {
        Int(self).toTime()
    }
}
