//
//  AppLogger.swift
//  ModularSwiftUIDemo
//

import Foundation
import os

enum AppLogger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "ModularSwiftUIDemo"

    static let network = Logger(subsystem: subsystem, category: "network")
    static let repository = Logger(subsystem: subsystem, category: "repository")
    static let navigation = Logger(subsystem: subsystem, category: "navigation")
    static let lifecycle = Logger(subsystem: subsystem, category: "lifecycle")
}

/// Debug-only logging toggles. No effect in Release builds.
enum LogConfiguration {
    #if DEBUG
    /// Flip to `true` when you need the full API response body in Xcode Console.
    static var logFullNetworkResponses = false
    #else
    static let logFullNetworkResponses = false
    #endif

    static let maxFullResponseLogBytes = 32_768
}

enum LogRedaction {
    private static let sensitiveQueryNames: Set<String> = [
        "api_key", "apikey", "token", "access_token", "key"
    ]

    static func sanitizedURL(_ url: URL?) -> String {
        guard let url, var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return "unknown"
        }
        if let queryItems = components.queryItems {
            components.queryItems = queryItems.map { item in
                guard sensitiveQueryNames.contains(item.name.lowercased()) else {
                    return item
                }
                return URLQueryItem(name: item.name, value: "<redacted>")
            }
        }
        return components.string ?? url.absoluteString
    }

    static func responseSummary(statusCode: Int, byteCount: Int) -> String {
        "status=\(statusCode) bytes=\(byteCount)"
    }

    /// Logs full response body when `LogConfiguration.logFullNetworkResponses` is enabled (Debug only).
    static func logFullResponseBodyIfEnabled(_ data: Data, url: String, statusCode: Int) {
        #if DEBUG
        guard LogConfiguration.logFullNetworkResponses else { return }
        logFullResponseBody(data, url: url, statusCode: statusCode, reason: "debug enabled")
        #endif
    }

    /// Always logs full response body in Debug — useful when decode or HTTP errors need inspection.
    static func logFullResponseBodyForDebugging(_ data: Data, url: String, statusCode: Int, reason: String) {
        #if DEBUG
        logFullResponseBody(data, url: url, statusCode: statusCode, reason: reason)
        #endif
    }

    private static func logFullResponseBody(_ data: Data, url: String, statusCode: Int, reason: String) {
        let body = preview(data)
        AppLogger.network.debug(
            "Full response body reason=\(reason, privacy: .public) url=\(url, privacy: .public) status=\(statusCode) body=\(body, privacy: .public)"
        )
    }

    private static func preview(_ data: Data) -> String {
        let capped = data.prefix(LogConfiguration.maxFullResponseLogBytes)
        let text = String(data: capped, encoding: .utf8) ?? "<non-utf8 body>"
        guard data.count > LogConfiguration.maxFullResponseLogBytes else { return text }
        return text + " … [truncated, total \(data.count) bytes]"
    }
}
