//
//  DIManagerEKey.swift
//  Media-SUI
//
//  Created by KsArT on 27.12.2024.
//

import SwiftUICore

struct DIEnvironmentKey: EnvironmentKey {
    static let defaultValue = DIManager()
}

extension EnvironmentValues {
    var diManager: DIManager {
        get { self[DIEnvironmentKey.self] }
        set { self[DIEnvironmentKey.self] = newValue }
    }
}

extension View {
    func environmentDI(_ value: DIManager) -> some View {
        environment(\.diManager, value)
    }
}
