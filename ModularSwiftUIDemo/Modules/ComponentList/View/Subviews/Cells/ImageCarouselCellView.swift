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
            LazyHGrid(rows: [GridItem(.flexible())]) {
                ForEach(items.indices, id: \.self) { index in
                    CarouselCardView(item: items[index], navigationPublisher: navigationPublisher)
                }
            }
        }
        .frame(height: 350)
    }
}
