//
//  HeaderCellView.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-06-11.
//
import SwiftUI

struct HeaderCellView: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .padding(.vertical, 8)
            Spacer()
        }
    }
    
    
}
