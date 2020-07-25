//
//  SudoguApp.swift
//  Shared
//
//  Created by Vijay Iyer on 7/25/20.
//

import SwiftUI

@main
struct SudoguApp: App {
    @Environment(\.scenePhase) var scenePhase
    var body: some Scene {
        windowGroup
            .onChange(of: scenePhase) { newPhase in
                sceneDidChange(scene: newPhase)
            }
    }
    
    var windowGroup: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    func sceneDidChange(scene: ScenePhase) {
        switch scene {
        case .inactive:
            // DO SOMETHING
            break
        case .background:
            // DO SOMETHING
            break
        default:
            // DO NOTHING
            break
        }
    }
}
