//
//  AppDependencies.swift
//  ModularSwiftUIDemo
//

import Foundation

enum AppDependencies {
    static func makeCoordinator(linkOpener: LinkOpening = SystemLinkOpener()) -> LegalPrivacyCoordinator {
        let repository = ComponentRepository()
        let service = ComponentService(repository: repository)
        let viewModel = LegalPrivacyViewModel(componentService: service)
        return LegalPrivacyCoordinator(viewModel: viewModel, linkOpener: linkOpener)
    }
}
