//
//  ModularSwiftUIDemoApp.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-06-13.
//

import SwiftUI

@main
struct ModularSwiftUIDemoApp: App {
    var body: some Scene {
            MainScene()
    }
}

struct MainScene: Scene {
    @StateObject private var coordinator = LegalPrivacyCoordinator()
    
    var body: some Scene {
        WindowGroup {
            coordinator.buildView()
        }
    }
}


