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
    
    // MARK: - Get Data File
    func fetchFile(dir: String, fileName: String) async -> Result<Data, any Error> {
        guard let path = getDirectoryUrl(dir) else { return .failure(LocalError.directoryError(dir)) }
        return if let (fileURL, isFileExists) = await getFileUrl(path: path, fileName: fileName), isFileExists,
                  let data = manager.contents(atPath: fileURL.path()) {
            .success(data)
        } else {
            .failure(LocalError.fileError(fileName))
        }
    }
    
    func fetchFile(fileUrl: URL) async -> Result<Data, any Error> {
        if manager.fileExists(atPath: fileUrl.path()), let data = manager.contents(atPath: fileUrl.path()) {
            return .success(data)
        } else {
            // попробуем по другому
            let fileName = fileUrl.lastPathComponent
            let dir = fileName.contains(Constants.imageExt) ? Constants.imageDir : fileName.contains(Constants.musicExt) ? Constants.musicDir : ""
            print("FileLocalService:\(#function): fetch files error = \(fileName) - \(dir)")
            return await fetchFile(dir: dir, fileName: fileName)
//            .failure(LocalError.fileError(fileUrl.lastPathComponent))
        }
    }
    
    // MARK: - File operations
    func saveFile(dir: String, fileName: String, data: Data) async -> Result<URL, any Error> {
        guard let path = getDirectoryUrl(dir) else { return .failure(LocalError.directoryError(dir)) }
        
        // проверить если файл есть
        return if let (fileURL, isFileExists) = await getFileUrl(path: path, fileName: fileName), isFileExists ||
                    manager.createFile(atPath: fileURL.path(),contents: data) {
            .success(fileURL)
        } else {
            .failure(LocalError.saveError(fileName))
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
    
    // MARK: - URL File and Directory
    private func getDirectoryUrl(_ dir: String) -> URL? {
        let directory = manager.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent(dir, conformingTo: .directory)
        print("FileLocalService:\(#function): dir: \(directory.absoluteString)")
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
    
    func getFileUrl(dir: String, fileName: String) async -> Result<URL, any Error> {
        guard let path = getDirectoryUrl(dir) else { return .failure(LocalError.directoryError(dir)) }
        return if let (fileURL, isFileExists) = await getFileUrl(path: path, fileName: fileName), isFileExists {
            .success(fileURL)
        } else {
            .failure(LocalError.fileError(fileName))
        }
    }
    
    private func getFileUrl(path: URL, fileName: String) async -> (URL, Bool)? {
        let fileUrl = path.appendingPathComponent(fileName, conformingTo: .fileURL)
        return  (fileUrl, manager.fileExists(atPath: fileUrl.path()))
    }
    
    func isFileExists(fileUrl: URL?) async -> Bool {
        guard let fileUrl else { return false }
        return manager.fileExists(atPath: fileUrl.path())
    }
}
