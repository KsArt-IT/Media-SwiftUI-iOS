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
    
    public func fetchData(id: String) async -> Result<TrackModel, any Error> {
        do {
            let fetch = FetchDescriptor<TrackModel>(
                predicate: #Predicate {
                    $0.id == id
                },
                sortBy: [SortDescriptor(\.id)]
            )
            try Task.checkCancellation()
            return if let track = try db.context.fetch(fetch).first {
                .success(track)
            } else {
                .failure(LocalError.fetchDbError(id))
            }
        } catch {
            print("DataLocalServiceImpl:\(#function): error: \(error.localizedDescription)")
            return .failure(LocalError.fetchDbError(error.localizedDescription))
        }
    }
    
    // MARK: - Save
    @MainActor
    public func saveData(track: TrackModel) async -> Result<Bool, any Error> {
        db.context.insert(track)
        save()
        return if case .success(_) = await fetchData(id: track.id) {
            .success(true)
        } else {
            .failure(LocalError.saveDbError(track.name))
        }
    }
    
    @MainActor
    private func save(_ force: Bool = false) {
        do {
            if force || db.context.hasChanges {
                try db.context.save()
                print("DataLocalServiceImpl:\(#function)")
            }
        } catch {
            print("DataLocalServiceImpl:\(#function): error: \(error)")
        }
    }
}
