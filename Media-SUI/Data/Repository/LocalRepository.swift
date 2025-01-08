//
//  LocalRepository.swift
//  Media-SUI
//
//  Created by KsArT on 07.01.2025.
//

import Foundation

protocol LocalRepository: AnyObject {
    func fetchRecorders() async -> Result<[Recording], any Error>
    func getNextRecordingUrl() async -> Result<URL, any Error>
    func fetchTracks() async -> Result<[Track], any Error>
    
    func rename(at url: URL, to name: String) async -> Result<URL, any Error>
    func delete(at url: URL) async -> Result<Bool, any Error>
}
