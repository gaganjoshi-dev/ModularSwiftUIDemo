//
//  LegalPrivacyCoordinator.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-06-05.
//

import SwiftUI
import Combine

protocol LegalPrivacyCoordinatorProtocol: AnyObject, CoordinatorProtocol {
    //func open(component: URL)
    func navigateToDetail(for item: CarouselItem)
}



final class LegalPrivacyCoordinator: ObservableObject, LegalPrivacyCoordinatorProtocol {

    // MARK: - Navigation Events
        enum NavigationEvent {
            case open(LinkDestination)
            case showDetail(CarouselItem)
        }

        // MARK: - State and Publishers

        @Published private(set) var navigationPath = NavigationPath()
        let navigationPublisher = PassthroughSubject<NavigationEvent, Never>()
        private var cancellables = Set<AnyCancellable>()

        // MARK: - Init

        init() {
            observeNavigationEvents()
        }

        deinit {
            cancellables.removeAll()
        }

        // MARK: - Observe Combine Events

        private func observeNavigationEvents() {
            navigationPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] event in
                    guard let self else { return }
                    self.handle(event)
                }
                .store(in: &cancellables)
        }

        private func handle(_ event: NavigationEvent) {
            switch event {
            case .open(let linkDestination):
                handleExternalLink(linkDestination)
            case .showDetail(let item):
                navigateToDetail(for: item)
            }
        }

        // MARK: - External Link Handling

        func handleExternalLink(_ destination: LinkDestination) {
            switch destination {
            case .deepLink(let url):
                openDeepLink(url)
            case .webLink(let url):
                openWebLink(url)
            case .unknown:
                print("⚠️ Unknown or invalid link. No action taken.")
            }
        }

        private func openDeepLink(_ url: URL) {
            print("🔗 Opening deep link: \(url.absoluteString)")
            // Add routing logic (e.g. navigate to specific view)
        }

        private func openWebLink(_ url: URL) {
            print("🌐 Opening web link: \(url.absoluteString)")
            // UIApplication.shared.open(url) — if needed
        }

        // MARK: - Detail Navigation

        func navigateToDetail(for item: CarouselItem) {
            //navigationPath.append(item) // CarouselItem must conform to Hashable
        }

        // MARK: - Root View

        @ViewBuilder
        func buildView() -> some View {
            NavigationStack(path: Binding(
                get: { self.navigationPath },
                set: { self.navigationPath = $0 }
            )) {
                LegalPrivacyView(
                    viewModel: LegalPrivacyViewModel(
                        componentService: ComponentService(
                            repository: ComponentRepository()
                        )
                    ),
                    coordinator: self
                )
            }
        }
}


