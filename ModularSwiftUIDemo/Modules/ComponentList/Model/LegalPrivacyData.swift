//
//  LegalPrivacyData.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-06-11.
//

struct LegalPrivacyData: Decodable {
    let page: Page
    let components: [Component]
}

enum ComponentType: String, Decodable {
    case header = "HEADER"
    case imageCarousel = "IMAGE_CAROUSEL"
    case actionCell = "ACTION_CELL"
}
struct Page: Decodable {
    let title : String
}

struct Component : Decodable {
    let type: ComponentType
    let title : String?
    let withBackground: Bool?
    let deeplink: String?
    let weblink: String?
    let items: [CarouselItem]?
    let image: ImageData?
    
    enum CodingKeys: String, CodingKey {
        case type
        case title
        case withBackground = "with_background"
        case deeplink
        case weblink
        case items
        case image
    }
}

struct CarouselItem: Decodable {
    let title: String
    let description: String
    let buttonTitle: String?
    let weblink: String
    let image: ImageData
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case buttonTitle = "button_title"
        case weblink
        case image
    }

}

struct ImageData: Decodable {
    let mobile: String?
    let web: String?
    let background: String?
}

