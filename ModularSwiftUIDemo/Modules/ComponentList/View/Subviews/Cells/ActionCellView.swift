//
//  ActionCellView.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-06-11.
//
import SwiftUI

struct ActionCellView: View {
    
    @EnvironmentObject var theme: ThemeManager
    
    let title: String
    let imageUrl: URL?
    let onTap: () -> Void
    
    
    var body: some View {
        HStack {
            AsyncImage(url: imageUrl) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                case .failure:
                    Image(imageUrl?.absoluteString ?? "")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                    
                default:
                    EmptyView()
                }
            }
            Text(title)
                .font(theme.detailFont)
                .foregroundStyle(theme.detailColor)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }.onTapGesture {
            onTap()
        }
    }
}
