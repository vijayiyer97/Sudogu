//
//  SudoguApp.swift
//  Sudogu (macOS)
//
//  Created by Vijay Iyer on 7/27/20.
//

import SwiftUI

@main
struct SudoguApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var sudoku: Sudoku = Sudoku.shared
    @StateObject var ui: UserInterface = UserInterface()

    var body: some Scene {
        windowGroup
            .onChange(of: scenePhase) { newPhase in
                sceneDidChange(scene: newPhase)
            }
    }
    
    var windowGroup: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sudoku)
                .environmentObject(ui)
                .onAppear {
                    sceneDidEnterForeground()
                }
        }
    }
    
    func sceneDidChange(scene: ScenePhase) {
        switch scene {
        case .active:
            sceneDidEnterForeground()
        case .inactive:
            sceneDidDisconnect()
        case .background:
            sceneDidEnterBackground()
        default:
            // DO NOTHING
            break
        }
    }
    
    func sceneDidEnterForeground() {
        
    }
    
    func sceneDidEnterBackground() {
        
    }
    
    func sceneDidDisconnect() {
        sceneDidEnterBackground()
    }
}

