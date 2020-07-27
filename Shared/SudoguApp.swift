//
//  SudoguApp.swift
//  Sudogu
//
//  Created by Vijay Iyer on 7/25/20.
//

import SwiftUI
import CoreData

@main
struct SudoguApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var sudoku: Sudoku = Sudoku.shared
    @StateObject var ui: UserInterface = UserInterface()
    @StateObject var haptics: HapticEngine = HapticEngine()
    @StateObject var volume: VolumeObserver = VolumeObserver()
    
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
        volume.subscribe() // start audio control engine
        haptics.start() // start haptic feedback engine
        
        // add haptic feedback audio resources
        guard let url_1 = Bundle.main.url(forResource: "hardClick", withExtension: "aiff"), let url_2 = Bundle.main.url(forResource: "softClick", withExtension: "aiff") else {
            return
        }
        haptics.addAudioResource(from: url_1, with: "hardClick")
        haptics.addAudioResource(from: url_2, with: "softClick")
    }
    
    func sceneDidEnterBackground() {
        volume.unsubscribe() // stop audio control engine
        haptics.stop() // stop haptic feedback engine
    }
    
    func sceneDidDisconnect() {
        
    }
}
