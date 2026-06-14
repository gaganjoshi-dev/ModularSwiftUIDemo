//
//  NetworkError.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-06-11.
//
import Foundation

enum NetworkError: Error {
    case invalidResponse(Int, String)
    case decodingFailed(Error)
    case clientError(Error)
}

extension NetworkError {

    /// Remote failures that should serve bundled local content instead of surfacing an error.
    var shouldFallbackToLocalContent: Bool {
        switch self {
        case .decodingFailed:
            return true
        case .clientError(let error):
            return Self.isConnectivityFailure(error)
        case .invalidResponse:
            return false
        }
    }

    var fallbackReason: LocalFallbackReason? {
        switch self {
        case .decodingFailed:
            return .invalidRemoteJSON
        case .clientError(let error) where Self.isConnectivityFailure(error):
            return .connectivityFailure
        case .clientError, .invalidResponse:
            return nil
        }
    }

    private static func isConnectivityFailure(_ error: Error) -> Bool {
        guard let urlError = error as? URLError else { return false }
        switch urlError.code {
        case .notConnectedToInternet,
             .networkConnectionLost,
             .timedOut,
             .cannotConnectToHost,
             .cannotFindHost,
             .dnsLookupFailed,
             .dataNotAllowed,
             .internationalRoamingOff:
            return true
        default:
            return false
        }
    }
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidResponse(_ , let message):
            return message
        case .decodingFailed(let error):
            return "Failed to decode JSON: \(error.localizedDescription)"
        case .clientError(let error):
            var msg = "Invalid Client Error from SDK."
            /// If able to access the URLError or not.
            guard let error = error as? URLError else {
                return NSLocalizedString(msg, comment: msg)
            }
            let errorCode = error.errorCode
            // Re-routing "App appears to be offline" to "No Network connectivity"
            if errorCode == -1009 {
                msg = "No network connectivity."
            }
            // Re-routing "Server took long time than expected" to "The request timed out"
            else if errorCode == -1001 {
                msg = "The request timed out."
            }
            // Re-routing "application could not connect with server" to "No active network connectivity"
            else if errorCode == -1004 {
                msg = "Could not connect to server."
            }
            // Set error msg as a default condition if error code not handled
            else {
                msg = error.localizedDescription
            }
            return NSLocalizedString(msg, comment: msg)
        }
    }
    
    var errorCode: String {
        switch self {
        case .invalidResponse(let code , _):
            return String(code)
        case .decodingFailed(_):
            return "-1001"
        case .clientError(let error):
            if let errorCode = (error as? URLError)?.errorCode {
                // Re-routing "App appears to be offline" to "No Network connectivity"
                if errorCode == -1009 {
                    return "-1002"
                    // Re-routing "Server took long time than expected" to "The request timed out"
                } else if errorCode == -1001 {
                    return "-1003"
                    // Re-routing "application could not connect with server" to "No active network connectivity"
                } else if errorCode == -1004 {
                    return "-1004"
                }
            }
            return  String((error as? URLError)?.errorCode ?? -1)
        }
    }
    
}


