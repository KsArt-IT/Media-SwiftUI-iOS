//
//  Media_SUIApp.swift
//  Media-SUI
//
//  Created by KsArT on 27.11.2024.
//

import SwiftUI

@main
struct Media_SUIApp: App {
    @Environment(\.diManager) private var di
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: di.resolve())
                .environmentDI(di)
        }
    }
    init() {
        debugPrint("Use api key: '\(MusicEndpoint.clientId)'")
        debugPrint(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
