//
//  FileLocalService.swift
//  Media-SUI
//
//  Created by KsArT on 07.01.2025.
//

import Foundation

final class FileLocalService: LocalService {
    private lazy var manager: FileManager = {
        FileManager.default
    }()
    private var maxIndex = 0

    func fetchFiles(url: URL) async -> Result<[FileDto], any Error> {
        do {
            let files = try manager.contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: [.creationDateKey],
                options: .skipsHiddenFiles
            )
            let list = files
                .compactMap { url -> FileDto? in
                    if url.pathExtension == Constants.recordingExt {
                        let attributes = try? FileManager.default.attributesOfItem(atPath: url.path())
                        let creationDate = attributes?[.creationDate] as? Date ?? Date.now
                        let fileName = url.lastPathComponent
                        let components = fileName.split(separator: "_")
                        let index = components.count > 1 ? Int(components[1]) ?? 0 : 0
                        if index > maxIndex {
                            maxIndex = index
                        }
                        
                        return FileDto(
                            n: index,
                            name: url.lastPathComponent,
                            url: url,
                            date: creationDate
                        )
                    } else {
                        return nil
                    }
                }
                .sorted(by: { $0.date < $1.date })
            return .success(list)
        } catch {
            print("FileLocalService:\(#function): fetch files error = \(error.localizedDescription)")
            return .failure(error)
        }

    }
    
    func rename(at url: URL, to name: String) async -> Result<URL, any Error> {
        let newURL = url.deletingLastPathComponent().appendingPathComponent(name)
        
        do {
            try manager.moveItem(at: url, to: newURL)
            return .success(newURL)
        } catch {
            print("FileLocalService:\(#function): error renaming file: \(error.localizedDescription)")
            return .failure(error)
        }

    }
    
    func delete(at url: URL) async -> Result<Bool, any Error> {
        do {
            try manager.removeItem(at: url)
            return .success(true)
        } catch {
            print("FileLocalService:\(#function): error deleting file \(error.localizedDescription)")
            return .failure(error)
        }

    }
    
}
