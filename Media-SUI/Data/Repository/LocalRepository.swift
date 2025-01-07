//
//  LocalRepository.swift
//  Media-SUI
//
//  Created by KsArT on 07.01.2025.
//

import Foundation

protocol LocalRepository: AnyObject {
    func fetchRecorders() async -> Result<[Recording], Error>
    func fetchTracks() async -> Result<[Track], Error>
    
    func rename(at url: URL, to name: String) async -> Result<URL, Error>
    func delete(at url: URL) async -> Result<Bool, Error>
}
