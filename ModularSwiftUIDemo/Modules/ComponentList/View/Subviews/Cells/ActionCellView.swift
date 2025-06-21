//
//  ActionCellView.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-06-11.
//
import SwiftUI

struct ActionCellView: View {
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
                default:
                    EmptyView()
                }
            }
            Text(title)
            Spacer()
            Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
        }.onTapGesture {
            onTap()
        }
    }
}
