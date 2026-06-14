//
//  ComponentService.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-06-10.
//
import Foundation

protocol ComponentServiceProtocol {
    func getComponentPageData() async throws -> ComponentPageResult
}

final class ComponentService: ComponentServiceProtocol {
    private let repository: ComponentRepositoryProtocol

    init(repository: ComponentRepositoryProtocol = ComponentRepository()) {
        self.repository = repository
    }

    func getComponentPageData() async throws -> ComponentPageResult {
        try await repository.fetchPage()
    }
}
