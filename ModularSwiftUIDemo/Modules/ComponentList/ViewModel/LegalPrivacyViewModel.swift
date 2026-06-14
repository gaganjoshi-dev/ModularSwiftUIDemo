//
//  LegalPrivacyViewModel.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-06-11.
//

import Foundation

enum LinkDestination {
    case deepLink(URL)
    case webLink(URL)
    case unknown
}

enum ComponentListState {
    case loading
    case loaded(title: String, components: [ComponentCellViewModel])
    case failure(String)
}

final class LegalPrivacyViewModel: ObservableObject {
    private let componentService: ComponentServiceProtocol
    @Published private(set) var state: ComponentListState = .loading

    init(componentService: ComponentServiceProtocol) {
        self.componentService = componentService
    }

    @MainActor
    func fetchLegalPrivacyData() async {
        AppLogger.repository.debug("ViewModel fetch started")
        state = .loading
        do {
            let result = try await componentService.getComponentPageData()
            let viewModels = result.data.components.map { ComponentCellViewModel(component: $0) }
            state = .loaded(
                title: result.data.page.title,
                components: viewModels
            )
            AppLogger.repository.debug(
                "ViewModel fetch succeeded source=\(result.source.rawValue, privacy: .public) componentCount=\(viewModels.count)"
            )
        } catch {
            state = .failure(error.localizedDescription)
            AppLogger.repository.error("ViewModel fetch failed error=\(error.localizedDescription, privacy: .public)")
        }
    }
}

struct ComponentCellViewModel: Identifiable {

    let id: String
    private let component: Component

    init(component: Component) {
        self.component = component
        self.id = component.identifier ?? UUID().uuidString
    }

    var title: String {
        component.title ?? ""
    }

    var type: ComponentType {
        component.type
    }

    var hasBackground: Bool {
        component.withBackground ?? false
    }

    var items: [CarouselItem]? {
        component.items
    }

    var linkDestination: LinkDestination {
        if let deeplink = makeURL(from: component.deeplink) {
            return .deepLink(deeplink)
        } else if let weblink = makeURL(from: component.weblink) {
            return .webLink(weblink)
        } else {
            return .unknown
        }
    }

    var imageUrl: URL? {
        guard let urlString = component.image?.mobile else { return nil }
        return makeURL(from: urlString)
    }

    private func makeURL(from string: String?) -> URL? {
        guard let string else { return nil }
        return URL(string: string)
    }
}
