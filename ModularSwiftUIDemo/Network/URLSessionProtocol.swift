//
//  URLSessionProtocol.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-06-09.
//
import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
