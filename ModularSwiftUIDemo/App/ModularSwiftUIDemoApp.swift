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
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            coordinator.buildView()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            switch newPhase {
            case .active:
                print("App is active")
            case .inactive:
                print("App is inactive")
            case .background:
                print("App is in background")
            @unknown default:
                break
            }
        }
    }
}



