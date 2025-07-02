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
        "secret"
    }
    var apiKeyHeader: String = "X-API-KEY"
    var baseURL: String = "https://stage-api.App.com"
    var channel: String = "app"
    var endpoint: String = "/guest_profile_details/v1/transparency"
    var fileName: String = "legal_privacy"
}

