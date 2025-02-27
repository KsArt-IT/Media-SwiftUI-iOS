//
//  DataService.swift
//  Media-SUI
//
//  Created by KsArT on 16.01.2025.
//

import Foundation

protocol DataService: AnyObject {
    func fetchData() async -> Result<[TrackModel], any Error>
    func fetchData(id: String) async -> Result<TrackModel, any Error>
    func saveData(track: TrackModel) async -> Result<Bool, any Error>
    func deleteData(id: String) async -> Result<Bool, any Error>
}
