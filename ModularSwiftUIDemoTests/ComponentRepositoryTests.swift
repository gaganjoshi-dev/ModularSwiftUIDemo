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

    @Test func fetchPage_returnsRemoteDataWhenRemoteSucceeds() async throws {
        let remote = MockComponentDataSource(result: .success(sampleData))
        let local = MockComponentDataSource(result: .failure(LocalDataError.fileNotFound))
        let repository = ComponentRepository(localRepository: local, remoteRepository: remote)

        let result = try await repository.fetchPage()

        #expect(result.data.page.title == "Test")
        #expect(result.source == .remote)
        #expect(result.fallbackReason == nil)
        #expect(local.fetchCount == 0)
    }

    @Test func fetchPage_fallsBackToLocalWhenOffline() async throws {
        let offlineError = ComponentError.networkError(
            .clientError(URLError(.notConnectedToInternet))
        )
        let remote = MockComponentDataSource(result: .failure(offlineError))
        let local = MockComponentDataSource(result: .success(sampleData))
        let repository = ComponentRepository(localRepository: local, remoteRepository: remote)

        let result = try await repository.fetchPage()

        #expect(result.data.page.title == "Test")
        #expect(result.source == .local)
        #expect(result.fallbackReason == .connectivityFailure)
        #expect(local.fetchCount == 1)
    }

    @Test func fetchPage_fallsBackToLocalWhenRemoteJSONInvalid() async throws {
        let decodingError = ComponentError.networkError(
            .decodingFailed(NSError(domain: "test", code: 1))
        )
        let remote = MockComponentDataSource(result: .failure(decodingError))
        let local = MockComponentDataSource(result: .success(sampleData))
        let repository = ComponentRepository(localRepository: local, remoteRepository: remote)

        let result = try await repository.fetchPage()

        #expect(result.source == .local)
        #expect(result.fallbackReason == .invalidRemoteJSON)
        #expect(local.fetchCount == 1)
    }

    @Test func fetchPage_fallsBackToLocalWhenTimedOut() async throws {
        let timeoutError = ComponentError.networkError(
            .clientError(URLError(.timedOut))
        )
        let remote = MockComponentDataSource(result: .failure(timeoutError))
        let local = MockComponentDataSource(result: .success(sampleData))
        let repository = ComponentRepository(localRepository: local, remoteRepository: remote)

        let result = try await repository.fetchPage()

        #expect(result.source == .local)
        #expect(local.fetchCount == 1)
    }

    @Test func fetchPage_doesNotFallbackOnUnauthorizedResponse() async throws {
        let unauthorized = ComponentError.networkError(.invalidResponse(401, "Unauthorized"))
        let remote = MockComponentDataSource(result: .failure(unauthorized))
        let local = MockComponentDataSource(result: .success(sampleData))
        let repository = ComponentRepository(localRepository: local, remoteRepository: remote)

        await #expect(throws: ComponentError.self) {
            try await repository.fetchPage()
        }
        #expect(local.fetchCount == 0)
    }

    @Test func fetchPage_doesNotFallbackOnMissingAPIKey() async throws {
        let remote = MockComponentDataSource(result: .failure(ComponentError.missingAPIKey))
        let local = MockComponentDataSource(result: .success(sampleData))
        let repository = ComponentRepository(localRepository: local, remoteRepository: remote)

        await #expect(throws: ComponentError.self) {
            try await repository.fetchPage()
        }
        #expect(local.fetchCount == 0)
    }

    @Test func fetchPage_wrapsLocalErrorsAfterConnectivityFallback() async throws {
        let offlineError = ComponentError.networkError(
            .clientError(URLError(.notConnectedToInternet))
        )
        let remote = MockComponentDataSource(result: .failure(offlineError))
        let local = MockComponentDataSource(result: .failure(LocalDataError.fileNotFound))
        let repository = ComponentRepository(localRepository: local, remoteRepository: remote)

        do {
            _ = try await repository.fetchPage()
            Issue.record("Expected ComponentError.localDataError")
        } catch let error as ComponentError {
            guard case .localDataError(.fileNotFound) = error else {
                Issue.record("Expected localDataError fileNotFound, got \(error)")
                return
            }
        } catch {
            Issue.record("Expected ComponentError, got \(error)")
        }
        #expect(local.fetchCount == 1)
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
