//
//  Repository.swift
//  Media-SUI
//
//  Created by KsArT on 02.12.2024.
//

import Foundation

protocol MusicRepository: AnyObject {
    func fetchTracks(page: Int) async -> Result<[Track], Error>
    func fetchTrack(url: String) async -> Result<Data, any Error>
}
