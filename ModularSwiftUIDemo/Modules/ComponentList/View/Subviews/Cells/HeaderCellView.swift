//
//  HeaderCellView.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-06-11.
//
import SwiftUI

struct HeaderCellView: View {
    
    @EnvironmentObject var theme: ThemeManager

    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(theme.titleFont)
                .foregroundStyle(theme.titleColor)
                .padding(.vertical, 8)
            Spacer()
        }
    }
    
    
}
