//
//  ComponentListView.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-06-11.
//
import SwiftUI
import Combine

struct ComponentListView: View {
   let components: [ComponentCellViewModel]
   let navigationPublisher: PassthroughSubject<LegalPrivacyCoordinator.NavigationEvent, Never>

    var body: some View {
        List(components, id: \.id) { component in
            switch component.type {
            case .header:
                HeaderCellView(title: component.title)
            case .actionCell:
                ActionCellView(title: component.title)
            case .imageCarousel:
                if let items = component.items, !items.isEmpty {
                    ImageCarouselCellView(items: items,navigationPublisher: navigationPublisher)
                } else {
                    EmptyView()
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}

