//
//  ComponentLoadingView.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-06-11.
//

import SwiftUI

struct ComponentLoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView("Loading...")
            Spacer()
        }
    }
}


#Preview {
    ComponentLoadingView()
}
