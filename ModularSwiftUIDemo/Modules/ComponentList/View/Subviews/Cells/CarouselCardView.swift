//
//  CarouselCardView.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-06-11.
//
import SwiftUI
import Combine

struct CarouselCardView: View {
    let item: CarouselItem
    let navigationPublisher: PassthroughSubject<LegalPrivacyCoordinator.NavigationEvent, Never>

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            CarouselImageView(urlString: item.image.mobile)
            CarouselTitleView(title: item.title)
            CarouselDescriptionView(description: item.description)
            if let buttonTitle = item.buttonTitle {
                CarouselLinkButton(title: buttonTitle, link: item.weblink,navigationPublisher: navigationPublisher)
            }
        }
        .frame(width: 160)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct CarouselImageView: View {
    let urlString: String?

    var body: some View {
        AsyncImage(url: URL(string: urlString ?? "")) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure(_):
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
            default:
                ProgressView()
            }
        }
        .frame(width: 150, height: 100)
        .clipped()
        .cornerRadius(10)
    }
}

struct CarouselTitleView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .lineLimit(1)
    }
}

struct CarouselDescriptionView: View {
    let description: String

    var body: some View {
        Text(description)
            .font(.subheadline)
            .lineLimit(2)
    }
}

struct CarouselLinkButton: View {
    let title: String
    let link: String
    let navigationPublisher: PassthroughSubject<LegalPrivacyCoordinator.NavigationEvent, Never>

    var body: some View {
        Button(title) {
                navigationPublisher.send(.openURL(link))
        }
        .font(.caption)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(5)
    }
}
