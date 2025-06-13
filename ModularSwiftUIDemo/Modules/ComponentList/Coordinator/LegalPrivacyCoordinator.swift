//
//  LegalPrivacyCoordinator.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-06-05.
//

import SwiftUI
import Combine

protocol LegalPrivacyCoordinatorProtocol: AnyObject, CoordinatorProtocol {
    func open(url: URL)
    func navigateToDetail(for item: CarouselItem)
}



final class LegalPrivacyCoordinator: ObservableObject, LegalPrivacyCoordinatorProtocol {

    enum NavigationEvent {
           case openURL(String)
           case showDetail(CarouselItem)
       }
    // MARK: - Navigation Path for In-App Routing
    @Published var navigationPath: NavigationPath = NavigationPath()

    
    // MARK: - Combine-based navigation
        let navigationPublisher = PassthroughSubject<NavigationEvent, Never>()
        private var cancellables = Set<AnyCancellable>()

        init() {
            observeNavigationEvents()
        }

        private func observeNavigationEvents() {
            navigationPublisher
                .sink { [weak self] event in
                    switch event {
                    case .openURL(let urlString):
                        guard let url = URL(string: urlString) else { return }
                        self?.open(url: url)

                    case .showDetail(let item):
                        self?.navigateToDetail(for: item)
                    }
                }
                .store(in: &cancellables)
        }
    
    
    
    // MARK: - External Link Navigation
    func open(url: URL) {
        UIApplication.shared.open(url)
    }

    // MARK: - Navigate to Carousel Detail
    func navigateToDetail(for item: CarouselItem) {
       // navigationPath.append(item)
    }

    // MARK: - Build Root View
    @ViewBuilder
    func buildView() -> some View {
        NavigationStack(path: Binding(
               get: { self.navigationPath },
               set: { self.navigationPath = $0 }
           )) {
               LegalPrivacyView(
                viewModel: LegalPrivacyViewModel(componentService: ComponentService(repository: RemoteRepository())),
                   coordinator: self
               )
           }
        }
}


