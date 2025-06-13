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
        ""
    }
    var apiKeyHeader: String = ""
    var baseURL: String = ""
    var channel: String = ""
    var endpoint: String = ""
    var fileName: String = ""
}
