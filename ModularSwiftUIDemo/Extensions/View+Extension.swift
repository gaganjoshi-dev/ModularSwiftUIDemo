//
//  MeasureSizeModifier.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-06-21.
//


import SwiftUI

import SwiftUI

struct MeasureSizeModifier: ViewModifier {
    let callback: (CGSize) -> Void

    func body(content: Content) -> some View {
        content
            .background {
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            callback(proxy.size)
                        }
                }
            }
    }
}

extension View {
    func measureSize(_ callback: @escaping (CGSize) -> Void) -> some View {
        self.modifier(MeasureSizeModifier(callback: callback))
    }
}
