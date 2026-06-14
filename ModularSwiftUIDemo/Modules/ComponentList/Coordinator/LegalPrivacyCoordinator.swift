//
//  LegalPrivacyCoordinator.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-06-05.
//

import SwiftUI
import Combine

protocol LegalPrivacyCoordinatorProtocol: AnyObject, CoordinatorProtocol {
    func navigateToDetail(for item: CarouselItem)
}

final class LegalPrivacyCoordinator: ObservableObject, LegalPrivacyCoordinatorProtocol {

    enum NavigationEvent {
        case open(LinkDestination)
        case showDetail(CarouselItem)
    }

    @Published private(set) var navigationPath = NavigationPath()
    let navigationPublisher = PassthroughSubject<NavigationEvent, Never>()
    let viewModel: LegalPrivacyViewModel
    private let linkOpener: LinkOpening
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: LegalPrivacyViewModel, linkOpener: LinkOpening = SystemLinkOpener()) {
        self.viewModel = viewModel
        self.linkOpener = linkOpener
        observeNavigationEvents()
    }

    deinit {
        cancellables.removeAll()
    }

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

    func handleExternalLink(_ destination: LinkDestination) {
        switch destination {
        case .deepLink(let url):
            openDeepLink(url)
        case .webLink(let url):
            openWebLink(url)
        case .unknown:
            AppLogger.navigation.debug("Ignored unknown link destination")
        }
    }

    private func openDeepLink(_ url: URL) {
        AppLogger.navigation.info("Opening deep link host=\(url.host ?? "unknown", privacy: .public)")
        linkOpener.open(url)
    }

    private func openWebLink(_ url: URL) {
        AppLogger.navigation.info("Opening web link host=\(url.host ?? "unknown", privacy: .public)")
        linkOpener.open(url)
    }

    func navigateToDetail(for item: CarouselItem) {
        // Reserved for future in-app detail navigation.
    }

    @ViewBuilder
    func buildView() -> some View {
        NavigationStack(path: Binding(
            get: { self.navigationPath },
            set: { self.navigationPath = $0 }
        )) {
            LegalPrivacyView(viewModel: viewModel, coordinator: self)
        }
    }
}
