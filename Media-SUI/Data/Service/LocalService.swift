//
//  LocalService.swift
//  Media-SUI
//
//  Created by KsArT on 07.01.2025.
//

import Foundation

protocol LocalService: AnyObject {
    func fetchFiles(url: URL) async -> Result<[FileDto], any Error>
    func rename(at url: URL, to name: String) async -> Result<URL, Error>
    func delete(at url: URL) async -> Result<Bool, Error>
}
