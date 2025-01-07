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
        registerRepository()
        registerRepository()
        registerRecorderViewModel()
        registerSearchScreenViewModel()
        registerPlayerViewModel()
        registerMusicListViewModel()
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
            FileLocalRepository(service: c.resolve(LocalService.self)!)
        }.inObjectScope(.container)
    }
    
    // MARK: - ViewModel
    private func registerRecorderViewModel() {
        container.register(RecorderViewModel.self) { c in
            RecorderViewModel()
        }.inObjectScope(.weak)
    }
    
    private func registerSearchScreenViewModel() {
        container.register(SearchScreenViewModel.self) { c in
            SearchScreenViewModel(repository: c.resolve(MusicRepository.self)!)
        }.inObjectScope(.weak)
    }
    
    private func registerPlayerViewModel() {
        container.register(PlayerViewModel.self) { c in
            PlayerViewModel()
        }.inObjectScope(.container)
    }
    
    private func registerMusicListViewModel() {
        container.register(MusicListViewModel.self) { c in
            MusicListViewModel()
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
                                                                  
