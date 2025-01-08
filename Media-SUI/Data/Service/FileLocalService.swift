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
    
    func fetchFiles(dir: String, ext: String, sortByName: Bool) async -> Result<[FileDto], any Error> {
        guard let url = getDirectoryUrl(dir) else { return .failure(LocalError.directoryError(dir)) }
        
        do {
            let files = try manager.contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: [.creationDateKey],
                options: .skipsHiddenFiles
            )
            let list = files
                .compactMap { url -> FileDto? in
                    if url.pathExtension == ext {
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
                .sorted(by: {
                    if sortByName {
                        $0.name < $1.name
                    } else {
                        $0.date < $1.date
                    }
                })
            return .success(list)
        } catch {
            print("FileLocalService:\(#function): fetch files error = \(error.localizedDescription)")
            return .failure(error)
        }
        
    }
    
    func getNextFileUrl(dir: String, ext: String, prefix: String) async -> Result<URL, any Error>  {
        maxIndex += 1
        let index = String(format: "%03d", maxIndex)
        let date = Date.now.toFileName()
        let fileName = "\(prefix)_\(index)_\(date).\(ext)"
        
        if let path = getDirectoryUrl(dir) {
            return .success(path.appendingPathComponent(fileName, conformingTo: .fileURL))
        }
        return .failure(LocalError.directoryError(dir))
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
    
    private func getDirectoryUrl(_ dir: String) -> URL? {
        
        let directory = manager.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent(dir, conformingTo: .directory)
        
        if !manager.fileExists(atPath: directory.path) {
            do {
                try manager.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("FileLocalService:\(#function): error directory not created \(error.localizedDescription)")
                return nil
            }
        }
        // TODO: оповестить пользователя, что каталог для записей не создан
        return directory
    }
    
}
