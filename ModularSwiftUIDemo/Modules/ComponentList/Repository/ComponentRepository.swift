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

    private let localRepository: ComponentDataSource
    private let remoteRepository: ComponentDataSource

    init(localRepository: ComponentDataSource = LocalRepository(),
         remoteRepository: ComponentDataSource = RemoteRepository()) {
        self.localRepository = localRepository
        self.remoteRepository = remoteRepository
    }

    func fetchComponents() async throws -> LegalPrivacyData {
        do {
            return try await remoteRepository.fetchComponents()
        } catch let error as ComponentError {
            if shouldFallbackToLocal(for: error) {
                return try await fetchLocal()
            }
            throw error
        } catch {
            throw ComponentError.unknown(error)
        }
    }

    private func fetchLocal() async throws -> LegalPrivacyData {
        do {
            return try await localRepository.fetchComponents()
        } catch let error as LocalDataError {
            throw ComponentError.localDataError(error)
        } catch {
            throw ComponentError.unknown(error)
        }
    }

    private func shouldFallbackToLocal(for error: ComponentError) -> Bool {
        switch error {
        case .invalidURL, .missingAPIKey:
            return true
        case .networkError(let networkError):
            let fallbackCodes = ["-1002", "-1003", "-1004"]
            return fallbackCodes.contains(networkError.errorCode)
        case .localDataError, .unknown:
            return false
        }
    }
}
