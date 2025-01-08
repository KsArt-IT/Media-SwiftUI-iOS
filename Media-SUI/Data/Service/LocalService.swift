//
//  LocalService.swift
//  Media-SUI
//
//  Created by KsArT on 07.01.2025.
//

import Foundation

protocol LocalService: AnyObject {
    func fetchFiles(dir: String, ext: String, sortByName: Bool) async -> Result<[FileDto], any Error>
    func getNextFileUrl(dir: String, ext: String, prefix: String) async -> Result<URL, any Error>
    func rename(at url: URL, to name: String) async -> Result<URL, any Error>
    func delete(at url: URL) async -> Result<Bool, any Error>
}
