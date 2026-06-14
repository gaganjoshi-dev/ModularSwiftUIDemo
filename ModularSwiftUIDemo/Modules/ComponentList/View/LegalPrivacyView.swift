//
//  LegalPrivacyView.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-06-11.
//

import SwiftUI
import Combine

struct LegalPrivacyView: View {
    @ObservedObject var viewModel: LegalPrivacyViewModel
    private let coordinator: LegalPrivacyCoordinator

    init(viewModel: LegalPrivacyViewModel, coordinator: LegalPrivacyCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
    }

    var body: some View {
        content
            .navigationTitle(navigationTitle)
            .task {
                await viewModel.fetchLegalPrivacyData()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ComponentLoadingView()
        case .failure(let message):
            ComponentErrorView(message: message)
        case .loaded(_, let components):
            ComponentListView(components: components, navigationPublisher: coordinator.navigationPublisher)
        }
    }

    private var navigationTitle: String {
        switch viewModel.state {
        case .loaded(let title, _):
            return title
        case .loading:
            return "Loading"
        case .failure:
            return "Error"
        }
    }
}
