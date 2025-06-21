//
//  APIConfig.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-06-09.
//

import Foundation


protocol APIConfigProtocol {
    var baseURL: String { get }
    var endpoint: String { get }
    var channel: String { get }
    var fileName: String { get }
    var apiKey: String? { get }
    var apiKeyHeader: String { get }
}

struct APIConfig: APIConfigProtocol {
    var apiKey: String? {
        "7a49485cc31ce633557e5af447e41014a78bd998"
    }
    var apiKeyHeader: String = "X-API-KEY"
    var baseURL: String = "https://stage-api.target.com"
    var channel: String = "app"
    var endpoint: String = "/guest_profile_details/v1/transparency"
    var fileName: String = "legal_privacy"
}
