//
//  ComponentError.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-06-05.
//


import Foundation

enum ComponentError: Error {
    case invalidURL
    case missingAPIKey
    case localDataError(LocalDataError)
    case networkError(NetworkError)
    case unknown(Error)
}

enum LocalFallbackReason: String {
    case connectivityFailure
    case invalidRemoteJSON
}

extension ComponentError {

    var shouldFallbackToLocalContent: Bool {
        switch self {
        case .networkError(let error):
            return error.shouldFallbackToLocalContent
        case .invalidURL, .missingAPIKey, .localDataError, .unknown:
            return false
        }
    }

    var fallbackReason: LocalFallbackReason? {
        switch self {
        case .networkError(let error):
            return error.fallbackReason
        case .invalidURL, .missingAPIKey, .localDataError, .unknown:
            return nil
        }
    }
}

extension ComponentError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided is invalid."
        case .missingAPIKey:
            return "API Key Missing"
        case .localDataError(let error):
            return error.localizedDescription
        case .networkError(let error):
            return error.localizedDescription
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}
