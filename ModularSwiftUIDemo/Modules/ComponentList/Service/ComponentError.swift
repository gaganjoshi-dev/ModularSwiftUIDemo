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

extension ComponentError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided is invalid."
        case .missingAPIKey:
            return "API Key Missing"
        case .localDataError(let error):
            return "Failed to decode JSON: \(error.localizedDescription)"
        case .networkError(let error):
            return "Failed to decode JSON: \(error.localizedDescription)"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}
