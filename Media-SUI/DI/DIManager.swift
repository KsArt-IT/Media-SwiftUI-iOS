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
        registerRecorderViewModel()
        registerSearchScreenViewModel()
        registerPlayerViewModel()
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
    
    // MARK: - Getting dependencies
    public func resolve<T>() -> T {
        resolve(T.self)!
    }
    
    public func resolve<T>(_ type: T.Type) -> T? {
        container.resolve(type)
    }
}
                                                                  
