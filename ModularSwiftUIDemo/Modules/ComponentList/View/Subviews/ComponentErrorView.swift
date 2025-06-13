//
//  ComponentErrorView.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-06-11.
//


import SwiftUI

struct ComponentErrorView: View {
    let message: String

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Text("Something went wrong")
                .font(.headline)
            Text(message)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
    }
}
