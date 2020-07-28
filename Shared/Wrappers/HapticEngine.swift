//
//  HapticEngine.swift
//  Sudogu (iOS)
//
//  Created by Vijay Iyer on 7/25/20.
//

import CoreHaptics

// MARK: HapticEngine
/**
 CoreHaptics wrapper for SwiftUI.
 */
final class HapticEngine: ObservableObject {
    /// The core haptics handler engine.
    private(set) var core: CHHapticEngine?
    /// The named map of accesible audio resources .
    private(set) var audioResources = [String : CHHapticAudioResourceID]()
    /// Flags whether core haptics is supported by the device.
    var available: Bool {
        CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }
    
    // Flags restart of engine.
    private var restartRequired: Bool = false
    
    // MARK: Initializers
    /// Initializes a `HapticEngine` instance.
    init() {
        guard available else { return }
        core = try? CHHapticEngine()
        core?.resetHandler = resetHandler
        core?.stoppedHandler = restartHandler
        core?.playsHapticsOnly = false
    }
    
    /// Starts the engine for haptic feedback.
    /// - Returns: `true` if startup was succesful, `false` if otherwise.
    @discardableResult
    func start() -> Bool {
        
        guard let _ = try? core?.start() else {
            restartRequired = true
            return false
        }
        
        restartRequired = false
        
        return true
    }
    
    /// Starts the engine for haptic feedback.
    ///
    /// Passes a completion handler to the engine and executes the block when control is passed.
    func start(completionHandler handler: @escaping (Error?) -> Void) {
        core?.start(completionHandler: handler)
        
        restartRequired = false
    }
    
    /// Stops the engine for haptic feedback.
    ///
    /// Passes a completion handler to the engine and executes the block when control is passed.
    func stop(completionHandler handler: CHHapticEngine.CompletionHandler? = nil) {
        core?.stop(completionHandler: handler)
    }
    
    // Resets the haptic feedback engine.
    private func resetHandler() {
        start()
    }

    // Restarts the haptic feedback engine.
    private func restartHandler(_ reasonForStopping: CHHapticEngine.StoppedReason? = nil) {
        resetHandler()
    }
    
    /// Adds an audio resource the the named map of available resources.
    /// - Parameter url: The file url to pointing to the resource.
    /// - Parameter key: The named key to assign to the resource.
    func addAudioResource(from url: URL, with key: String) {
        guard let id = try? core?.registerAudioResource(url, options: [:]) else {
            return
        }
        
        audioResources[key] = id
    }
    
    /// Removes an audio resource the the named map of available resources.
    /// - Parameter key: The named key to remove from the resource map.
    func removeAudioResource(with key: String) {
        guard let id = audioResources.removeValue(forKey: key) else {
            return
        }
        
        try? core?.unregisterAudioResource(id)
    }
    
    /**
     A parameter for creating a haptic feedback event.
     */
    class FeedbackParameter {
        private(set) var intensity: Float = 1
        private(set) var sharpness: Float = 1
        private(set) var sustain: Float = 0

        private(set) var attack: Float = 0.5
        private(set) var decay: Float = 0.5
        private(set)  var release: Float = 0.5
        
        private(set) var frequency: Float = 0.5
        private(set) var pitch: Float = 0
        private(set) var volume: Float = 0.5
        
        private(set) var audioResource: CHHapticAudioResourceID?

        private(set) var delay: TimeInterval = 0
        private(set) var duration: TimeInterval = 1
                        
        private var bounds: ClosedRange<Float> = 0.0...1.0
        
        /// Initializes an empty event feedback parameter.
        init() { }
        
        /// Sets parameters for haptic feedback.
        /// - Parameter intensity: A `Float`value  in the range `0...1`.
        /// - Parameter sharpness: A `Float` value in the range `0...1`.
        /// - Parameter attack: A `Float` value in the range `0...1`.
        /// - Parameter decay: A `Float` value in the range `0...1`.
        /// - Parameter release: A `Float` value in the range `0...1`.
        /// - Parameter sustain: A `Float` value in the range `0...1`.
        func setHapticsParameters(intensity: Float = 1, sharpness: Float = 1, attack: Float = 0.5, decay: Float = 0.5, release: Float = 0.5, sustain: Float = 0) -> Self {
            if bounds ~= intensity {
                self.intensity = intensity
            }
            if bounds ~= sharpness {
                self.sharpness = sharpness
            }
            if bounds ~= attack {
                self.attack = attack
            }
            if bounds ~= decay {
                self.decay = decay
            }
            if bounds ~= release {
                self.release = release
            }
            if bounds ~= sustain {
                self.sustain = sustain
            }
            
            return self
        }
        
        /// Sets parameters for audio feedback.
        /// - Parameter frequency: A `Float` value  in the range `0...1`.
        /// - Parameter pitch: A `Float` value in the range `-1...1`.
        /// - Parameter volume: A `Float` value in the range `0...1`.
        func setAudioParameters(frequency: Float = 0.5, pitch: Float = 0, volume: Float = 0.5, audioResource: CHHapticAudioResourceID? = nil) -> Self{
            if bounds ~= frequency {
                self.frequency = frequency
            }
            if bounds ~= abs(pitch) {
                self.pitch = pitch
            }
            if bounds ~= volume {
                self.volume = volume
            }
            
            self.audioResource = audioResource
            
            return self
        }
        
        /// Sets parameters for feedback delay and duration.
        /// - Parameter delay: A `TimeInterval` value.
        /// - Parameter duration: A `TimeInterval` value.
        func setTimeParameters(delay: TimeInterval = 0, duration: TimeInterval = 1) -> Self {
            if delay >= 0 {
                self.delay = delay
            }
            if duration >= 0 {
                self.duration = duration
            }
            
            return self
        }
        
    }
    
    /// Fires a haptic feedback event with given parameters.
    /// - Parameter parameter: A`FeedbackParameter` value.
    /// - Parameter count: The number of times to repeat the haptic feedback event.
    func fire(with parameter: FeedbackParameter = FeedbackParameter(), repeating count: Int = 1) {
        // make sure that the device supports haptics
        guard available else {
            return
        }
        
        var events = [CHHapticEvent]()
        
        // create two instances, sharp tap
        for i in stride(from: 0, to: Double(count), by: 1) {
            // haptic events
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: parameter.intensity)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: parameter.sharpness)
            let sustain = CHHapticEventParameter(parameterID: .sustained, value: parameter.sustain)
            let attack = CHHapticEventParameter(parameterID: .attackTime, value: parameter.attack)
            let decay = CHHapticEventParameter(parameterID: .decayTime, value: parameter.decay)
            let release = CHHapticEventParameter(parameterID: .releaseTime, value: parameter.release)
            
            // audio events
            let brightness = CHHapticEventParameter(parameterID: .audioBrightness, value: parameter.frequency)
            let pitch = CHHapticEventParameter(parameterID: .audioPitch, value: parameter.pitch)
            let volume = CHHapticEventParameter(parameterID: .audioVolume, value: parameter.volume)

            let hapticEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [
                intensity, sharpness, sustain, // haptics
                attack, decay, release // time
            ], relativeTime: parameter.delay * i)
            events.append(hapticEvent)

            if let audioResource = parameter.audioResource {
                let audioEvent = CHHapticEvent(audioResourceID: audioResource, parameters: [
                    brightness, pitch, volume
                ], relativeTime: parameter.delay * i, duration: parameter.duration)

                events.append(audioEvent)
            }
        }
        
        playEvents(events: events)
    }
    
    /// Fires a haptic feedback event with given parameters.
    /// - Parameter parameters: An array of `FeedbackParameter` values.
    func fire(with parameters: [FeedbackParameter]) {
        // make sure that the device supports haptics
        guard available else {
            return
        }
        var events = [CHHapticEvent]()
        
        // create two instances, sharp tap
        for parameter in parameters {
            // haptic events
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: parameter.intensity)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: parameter.sharpness)
            let sustain = CHHapticEventParameter(parameterID: .sustained, value: parameter.sustain)
            let attack = CHHapticEventParameter(parameterID: .attackTime, value: parameter.attack)
            let decay = CHHapticEventParameter(parameterID: .decayTime, value: parameter.decay)
            let release = CHHapticEventParameter(parameterID: .releaseTime, value: parameter.release)
            
            // audio events
            let brightness = CHHapticEventParameter(parameterID: .audioBrightness, value: parameter.frequency)
            let pitch = CHHapticEventParameter(parameterID: .audioPitch, value: parameter.pitch)
            let volume = CHHapticEventParameter(parameterID: .audioVolume, value: parameter.volume)

            let hapticEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [
                intensity, sharpness, sustain, // haptics
                attack, decay, release // time
            ], relativeTime: parameter.delay)
            events.append(hapticEvent)

            if let audioResource = parameter.audioResource {
                let audioEvent = CHHapticEvent(audioResourceID: audioResource, parameters: [
                    brightness, pitch, volume
                ], relativeTime: parameter.delay, duration: parameter.duration)

                events.append(audioEvent)
            }
        }
        
        playEvents(events: events)
    }
    
    // Plays haptic feedback events.
    private func playEvents(events: [CHHapticEvent]) {
        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try core?.makePlayer(with: pattern)
            if restartRequired {
                start()
            }
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
}
