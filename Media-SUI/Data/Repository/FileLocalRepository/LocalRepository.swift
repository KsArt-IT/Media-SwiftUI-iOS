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

    func isFileExists(fileUrl: URL?) async -> Bool
    func saveFile(dir: String, name: String, data: Data) async -> Result<URL, any Error>
    func rename(at url: URL, to name: String) async -> Result<URL, any Error>
    func delete(at url: URL) async -> Result<Bool, any Error>
    
    func fetchData() async -> Result<[Track], any Error>
    func fetchData(id: String) async -> Result<Track, any Error>
    func saveData(track: Track) async -> Result<Bool, any Error>
}
