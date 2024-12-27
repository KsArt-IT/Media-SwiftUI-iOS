//
//  Media_SUIApp.swift
//  Media-SUI
//
//  Created by KsArT on 27.11.2024.
//

import SwiftUI

@main
struct Media_SUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    init() {
        print("Use api key: '\(MusicEndpoint.clientId)'")
    }
}
