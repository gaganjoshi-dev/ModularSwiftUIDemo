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
    @StateObject private var coordinator = AppDependencies.makeCoordinator()
    @StateObject private var themeManager = ThemeManager()
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            coordinator.buildView()
                .environmentObject(themeManager)
        }
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .active:
                AppLogger.lifecycle.debug("App became active")
            case .inactive:
                AppLogger.lifecycle.debug("App became inactive")
            case .background:
                AppLogger.lifecycle.debug("App entered background")
            @unknown default:
                break
            }
        }
    }
}
