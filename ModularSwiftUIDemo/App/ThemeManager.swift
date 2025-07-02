//
//  ThemeManager.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-07-02.
//


import SwiftUI

class ThemeManager: ObservableObject {
    @Published var titleFont: Font = .subheadline
    @Published var titleColor: Color = .blue
    @Published var detailFont: Font = .caption
    @Published var detailColor: Color = .gray
}
