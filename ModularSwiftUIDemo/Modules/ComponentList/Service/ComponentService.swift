//
//  ComponentService.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-06-10.
//
import Foundation

protocol ComponentServiceProtocol {
    func getComponentPageData() async throws -> LegalPrivacyData
}

final class ComponentService: ComponentServiceProtocol {
    private let repository: ComponentDataSource

    init(repository: ComponentDataSource) {
        self.repository = repository
    }

    func getComponentPageData() async throws -> LegalPrivacyData {
        return try await repository.fetchComponents()
    }
}
