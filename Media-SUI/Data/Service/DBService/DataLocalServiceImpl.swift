//
//  DataLocalServiceImpl.swift
//  Media-SUI
//
//  Created by KsArT on 16.01.2025.
//

import Foundation
import SwiftData

final class DataLocalServiceImpl: DataService {
    private let db: DataBase

    init(db: DataBase) {
        self.db = db
    }
    
    public func fetchData() async -> Result<[TrackModel], any Error> {
        do {
            let result = try db.context.fetch(FetchDescriptor<TrackModel>())
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
}
