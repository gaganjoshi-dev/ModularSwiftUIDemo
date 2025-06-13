//
//  ComponentRepository.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-06-09.
//

import Foundation

protocol ComponentDataSource {
    func fetchComponents() async throws -> LegalPrivacyData
}

final class ComponentRepository: ComponentDataSource {
    
    private let localRepository: LocalRepository
    private let remoteRepository: RemoteRepository
    
    init(localRepository: LocalRepository = LocalRepository(),
         remoteRepository: RemoteRepository = RemoteRepository()) {
        self.localRepository = localRepository
        self.remoteRepository = remoteRepository
    }
    
    func fetchComponents() async throws -> LegalPrivacyData {
        do {
            return try await remoteRepository.fetchComponents()
        } catch let error as ComponentError {
            if case .networkError(let error) = error, error.errorCode == "-1002" {
                return try await localRepository.fetchComponents()
            } else {
                throw error
            }
        }
    }
    
    
}
