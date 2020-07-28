//
//  VolumeObserver.swift
//  Sudogu
//
//  Created by Vijay Iyer on 7/25/20.
//

import SwiftUI
import Foundation
import MediaPlayer

/**
 AVAudioSession wrapper for SwiftUI.
 */
public final class VolumeObserver: ObservableObject {
    /// The current volume level.
    @Published var level: Float = AVAudioSession.sharedInstance().outputVolume

    // Audio session object
    private let session = AVAudioSession.sharedInstance()

    // Observer
    private var progressObserver: NSKeyValueObservation!

    /// Subscribes the app to the  current `AVAudioSession`.
    func subscribe() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("cannot activate session")
        }

        progressObserver = session.observe(\.outputVolume) { [self] (session, value) in
            DispatchQueue.main.async {
                level = session.outputVolume
            }
        }
    }

    /// Unsubscribes the app from  the  current `AVAudioSession`.
    func unsubscribe() {
        progressObserver.invalidate()
    }
}
