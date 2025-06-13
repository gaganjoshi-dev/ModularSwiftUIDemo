//
//  ImageCarouselCellView.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-06-11.
//
import SwiftUI
import Combine


struct ImageCarouselCellView: View {
    let items: [CarouselItem]
    let navigationPublisher: PassthroughSubject<LegalPrivacyCoordinator.NavigationEvent, Never>

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(items.indices, id: \.self) { index in
                    let item = items[index]
                    CarouselCardView(item: item,navigationPublisher: navigationPublisher)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 220)
    }
}
