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

enum ContentDataSource: String {
    case remote
    case local
}

struct ComponentPageResult {
    let data: LegalPrivacyData
    let source: ContentDataSource
    let fallbackReason: LocalFallbackReason?
}

protocol ComponentRepositoryProtocol {
    func fetchPage() async throws -> ComponentPageResult
}

final class ComponentRepository: ComponentRepositoryProtocol {

    private let localRepository: ComponentDataSource
    private let remoteRepository: ComponentDataSource

    init(localRepository: ComponentDataSource = LocalRepository(),
         remoteRepository: ComponentDataSource = RemoteRepository()) {
        self.localRepository = localRepository
        self.remoteRepository = remoteRepository
    }

    func fetchPage() async throws -> ComponentPageResult {
        AppLogger.repository.debug("Fetch started source=remote")

        do {
            let data = try await remoteRepository.fetchComponents()
            logLoaded(data, source: .remote)
            return ComponentPageResult(data: data, source: .remote, fallbackReason: nil)
        } catch let error as ComponentError {
            if let reason = error.fallbackReason {
                AppLogger.repository.notice(
                    "Fallback to local reason=\(reason.rawValue, privacy: .public) error=\(error.localizedDescription, privacy: .public)"
                )
                let data = try await fetchLocal()
                logLoaded(data, source: .local, fallbackReason: reason)
                return ComponentPageResult(data: data, source: .local, fallbackReason: reason)
            }
            AppLogger.repository.error("Fetch failed source=remote error=\(error.localizedDescription, privacy: .public)")
            throw error
        } catch {
            AppLogger.repository.error("Fetch failed source=remote error=\(error.localizedDescription, privacy: .public)")
            throw ComponentError.unknown(error)
        }
    }

    private func fetchLocal() async throws -> LegalPrivacyData {
        AppLogger.repository.debug("Fetch started source=local")
        do {
            return try await localRepository.fetchComponents()
        } catch let error as LocalDataError {
            AppLogger.repository.error("Local fetch failed error=\(error.localizedDescription, privacy: .public)")
            throw ComponentError.localDataError(error)
        } catch {
            AppLogger.repository.error("Local fetch failed error=\(error.localizedDescription, privacy: .public)")
            throw ComponentError.unknown(error)
        }
    }

    private func logLoaded(_ data: LegalPrivacyData, source: ContentDataSource, fallbackReason: LocalFallbackReason? = nil) {
        if let fallbackReason {
            AppLogger.repository.info(
                "Content loaded source=\(source.rawValue, privacy: .public) fallbackReason=\(fallbackReason.rawValue, privacy: .public) title=\(data.page.title, privacy: .public) componentCount=\(data.components.count)"
            )
        } else {
            AppLogger.repository.info(
                "Content loaded source=\(source.rawValue, privacy: .public) title=\(data.page.title, privacy: .public) componentCount=\(data.components.count)"
            )
        }
    }
}
