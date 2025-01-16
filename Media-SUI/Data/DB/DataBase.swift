//
//  DataBase.swift
//  Media-SUI
//
//  Created by KsArT on 16.01.2025.
//

import SwiftData

final class DataBase {
    private var container: ModelContainer = {
        do {
            let container = try ModelContainer(
                for: TrackModel.self,
                configurations: ModelConfiguration()
            )
            return container
        } catch {
            fatalError("Failed to create a container SwiftData")
        }
    }()
    
    lazy var context: ModelContext = {
        let context = ModelContext(self.container)
        context.autosaveEnabled = false
        return context
    }()
}
