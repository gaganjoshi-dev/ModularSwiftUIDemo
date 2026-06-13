//
//  ComponentRepositoryTests.swift
//  ModularSwiftUIDemoTests
//

import Foundation
import Testing
@testable import ModularSwiftUIDemo

struct ComponentRepositoryTests {

    private let sampleData: LegalPrivacyData = {
        let json = """
        {"page":{"title":"Test"},"components":[]}
        """
        return try! JSONDecoder().decode(LegalPrivacyData.self, from: Data(json.utf8))
    }()

    @Test func fetchComponents_returnsRemoteDataWhenRemoteSucceeds() async throws {
        let remote = MockComponentDataSource(result: .success(sampleData))
        let local = MockComponentDataSource(result: .failure(LocalDataError.fileNotFound))
        let repository = ComponentRepository(localRepository: local, remoteRepository: remote)

        let result = try await repository.fetchComponents()

        #expect(result.page.title == "Test")
        #expect(local.fetchCount == 0)
    }

    @Test func fetchComponents_fallsBackToLocalWhenOffline() async throws {
        let offlineError = ComponentError.networkError(
            .clientError(URLError(.notConnectedToInternet))
        )
        let remote = MockComponentDataSource(result: .failure(offlineError))
        let local = MockComponentDataSource(result: .success(sampleData))
        let repository = ComponentRepository(localRepository: local, remoteRepository: remote)

        let result = try await repository.fetchComponents()

        #expect(result.page.title == "Test")
        #expect(local.fetchCount == 1)
    }

    @Test func fetchComponents_propagatesNonFallbackRemoteErrors() async throws {
        let decodingError = ComponentError.networkError(
            .decodingFailed(NSError(domain: "test", code: 1))
        )
        let remote = MockComponentDataSource(result: .failure(decodingError))
        let local = MockComponentDataSource(result: .success(sampleData))
        let repository = ComponentRepository(localRepository: local, remoteRepository: remote)

        await #expect(throws: ComponentError.self) {
            try await repository.fetchComponents()
        }
        #expect(local.fetchCount == 0)
    }

    @Test func fetchComponents_wrapsLocalErrors() async throws {
        let remote = MockComponentDataSource(
            result: .failure(ComponentError.invalidURL)
        )
        let local = MockComponentDataSource(result: .failure(LocalDataError.fileNotFound))
        let repository = ComponentRepository(localRepository: local, remoteRepository: remote)

        do {
            _ = try await repository.fetchComponents()
            Issue.record("Expected ComponentError.localDataError")
        } catch let error as ComponentError {
            guard case .localDataError(.fileNotFound) = error else {
                Issue.record("Expected localDataError fileNotFound, got \(error)")
                return
            }
        } catch {
            Issue.record("Expected ComponentError, got \(error)")
        }
    }
}

private final class MockComponentDataSource: ComponentDataSource {
    private let result: Result<LegalPrivacyData, Error>
    private(set) var fetchCount = 0

    init(result: Result<LegalPrivacyData, Error>) {
        self.result = result
    }

    func fetchComponents() async throws -> LegalPrivacyData {
        fetchCount += 1
        return try result.get()
    }
}
