//
//  NetworkErrorTests.swift
//  ModularSwiftUIDemoTests
//

import Foundation
import Testing
@testable import ModularSwiftUIDemo

struct NetworkErrorTests {

    @Test func shouldFallbackToLocalContent_isTrueForDecodingFailure() {
        let error = NetworkError.decodingFailed(NSError(domain: "test", code: 1))
        #expect(error.shouldFallbackToLocalContent == true)
        #expect(error.fallbackReason == .invalidRemoteJSON)
    }

    @Test func shouldFallbackToLocalContent_isTrueForConnectivityErrors() {
        let errors: [URLError.Code] = [
            .notConnectedToInternet,
            .timedOut,
            .cannotConnectToHost,
            .cannotFindHost,
            .dnsLookupFailed
        ]

        for code in errors {
            let error = NetworkError.clientError(URLError(code))
            #expect(error.shouldFallbackToLocalContent == true)
            #expect(error.fallbackReason == .connectivityFailure)
        }
    }

    @Test func shouldFallbackToLocalContent_isFalseForHTTPError() {
        let error = NetworkError.invalidResponse(500, "Server Error")
        #expect(error.shouldFallbackToLocalContent == false)
        #expect(error.fallbackReason == nil)
    }

    @Test func componentError_doesNotFallbackForMissingAPIKey() {
        let error = ComponentError.missingAPIKey
        #expect(error.shouldFallbackToLocalContent == false)
        #expect(error.fallbackReason == nil)
    }
}
