//
//  Untitled.swift
//  LegalPrivacyViewModel
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
        state = .loading
        do {
            let result = try await componentService.getComponentPageData()
            let viewModels = result.components.map { ComponentCellViewModel(component: $0) }
            state = .loaded(title: result.page.title, components: viewModels)
        } catch {
            state = .failure(error.localizedDescription)
        }
    }
}


protocol ComponentCellViewModelProtocol {
    var title: String { get }
    var type: ComponentType { get }
    var hasBackground: Bool { get }
    var items: [CarouselItem]? { get }
    var deeplink: URL? { get }
    var weblink: URL? { get }
}

struct ComponentCellViewModel: Identifiable  {
    
    let id = UUID()
    
    private let component : Component
    
    init(component: Component) {
        self.component = component
    }
    var title: String {
        return component.title ?? ""
    }
    var type: ComponentType {
        return component.type
    }
    var hasBackground: Bool {
        return component.withBackground ?? false
    }
    var items: [CarouselItem]?  {
        return component.items
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
        guard let string = string else { return nil }
        return URL(string: string)
    }
    
}
