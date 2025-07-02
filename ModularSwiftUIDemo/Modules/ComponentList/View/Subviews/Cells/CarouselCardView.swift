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
    
    @State private var viewSize: CGSize?
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            CarouselImageView(urlString: item.image.mobile) { size in
                print(size)
                viewSize = size
            }
            if let size = viewSize {
                CarouselTitleView(title: item.title).frame(width: size.width)
                CarouselDescriptionView(description: item.description).frame(width: size.width)
            } else {
                CarouselTitleView(title: item.title)
                CarouselDescriptionView(description: item.description)
            }
            if let buttonTitle = item.buttonTitle {
                CarouselLinkButton(title: buttonTitle, link: item.weblink,navigationPublisher: navigationPublisher)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct CarouselImageView: View {
    let urlString: String?
    let sizeOfImage: (CGSize) -> Void
    
    var body: some View {
        AsyncImage(url: URL(string: urlString ?? "")) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .measureSize { size in
                        print("✅ Image loaded with size: \(size)")
                        sizeOfImage(size)
                    }
                
            case .failure(_):
                Image(urlString ?? "")
                    .resizable()
                    .scaledToFit()
                    .measureSize { size in
                        print("✅ Image loaded with size: \(size)")
                        sizeOfImage(size)
                    }
                
            default:
                ProgressView()
            }
        }
        .clipped()
        .cornerRadius(10)
    }
}


struct CarouselTitleView: View {
    let title: String
    @EnvironmentObject var theme: ThemeManager

    var body: some View {
        Text(title)
            .font(theme.titleFont)
            .foregroundStyle(theme.titleColor)
            .lineLimit(1)
    }
}

struct CarouselDescriptionView: View {
    let description: String
    @EnvironmentObject var theme: ThemeManager

    var body: some View {
        Text(description)
            .font(theme.detailFont)
            .foregroundStyle(theme.detailColor)
            .font(.subheadline)
            .lineLimit(4)
    }
}

struct CarouselLinkButton: View {
    let title: String
    let link: String
    let navigationPublisher: PassthroughSubject<LegalPrivacyCoordinator.NavigationEvent, Never>
    
    var body: some View {
        Button(action: {
            if let url = URL(string: title) {
                navigationPublisher.send(.open(.deepLink(url)))
            }
        }) {
            Text(title)
                .font(.subheadline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
        .padding(.top, 4)
    }
}
