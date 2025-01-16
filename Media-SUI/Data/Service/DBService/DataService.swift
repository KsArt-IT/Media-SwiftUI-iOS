//
//  DataService.swift
//  Media-SUI
//
//  Created by KsArT on 16.01.2025.
//

import Foundation

protocol DataService: AnyObject {
    func fetchData() async -> Result<[TrackModel], any Error>
}
