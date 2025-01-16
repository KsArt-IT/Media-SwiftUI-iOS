//
//  DIManager.swift
//  Media-SUI
//
//  Created by KsArT on 27.12.2024.
//

import Foundation
import Swinject

final class DIManager {
    private let container = Container()
    
    // MARK: - Registering dependencies
    init() {
        registerDataRepository()
        
        registerRepository()
        registerLocalRepository()
        
        registerRecorderViewModel()
        registerSearchScreenViewModel()
        registerPlayerViewModel()
        registerMusicListViewModel()
    }
    
    // MARK: DataBase
    private func registerDataRepository() {
        container.register(DataBase.self) { _ in
            DataBase()
        }.inObjectScope(.weak)

        container.register(DataService.self) { c in
            DataLocalServiceImpl(db: c.resolve(DataBase.self)!)
        }.inObjectScope(.container)
    }
    
    // MARK: Repository
    private func registerRepository() {
        container.register(MusicService.self) { _ in
            JamendoMusicServiceImpl()
        }.inObjectScope(.weak)
        
        container.register(MusicRepository.self) { c in
            JamendoMusicRepositoryImpl(service: c.resolve(MusicService.self)!)
        }.inObjectScope(.container)
    }
    
    private func registerLocalRepository() {
        container.register(LocalService.self) { _ in
            FileLocalService()
        }.inObjectScope(.weak)
        
        container.register(LocalRepository.self) { c in
            FileLocalRepository(
                service: c.resolve(LocalService.self)!,
                dataService: c.resolve(DataService.self)!
            )
        }.inObjectScope(.container)
    }
    
    // MARK: - ViewModel
    private func registerRecorderViewModel() {
        container.register(RecorderViewModel.self) { c in
            RecorderViewModel(repository: c.resolve(LocalRepository.self)!)
        }.inObjectScope(.weak)
    }
    
    private func registerSearchScreenViewModel() {
        container.register(SearchScreenViewModel.self) { c in
            SearchScreenViewModel(
                repository: c.resolve(MusicRepository.self)!,
                localRepository: c.resolve(LocalRepository.self)!
            )
        }.inObjectScope(.weak)
    }
    
    private func registerPlayerViewModel() {
        container.register(PlayerViewModel.self) { c in
            PlayerViewModel()
        }.inObjectScope(.container)
    }
    
    private func registerMusicListViewModel() {
        container.register(MusicListViewModel.self) { c in
            MusicListViewModel(localRepository: c.resolve(LocalRepository.self)!)
        }.inObjectScope(.container)
    }
    
    // MARK: - Getting dependencies
    public func resolve<T>() -> T {
        resolve(T.self)!
    }
    
    public func resolve<T>(_ type: T.Type) -> T? {
        container.resolve(type)
    }
}
                                                                  
