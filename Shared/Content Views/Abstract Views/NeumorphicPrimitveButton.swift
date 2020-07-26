//
//  NeumorphicPrimitveButton.swift
//  Sudogu
//
//  Created by Vijay Iyer on 7/25/20.
//

import SwiftUI

/**
 A primitive button style that adopts neumorphism.
 */
struct NeumorphicPrimitveButton<S: Shape>: PrimitiveButtonStyle {
    let shape: S
    
    func makeBody(configuration: Self.Configuration) -> some View {
        ButtonView(configuration: configuration, shape: shape)
    }

}

private extension NeumorphicPrimitveButton {
    /**
     Sets the view of the button.
     */
    struct ButtonView<S: Shape>: View {
        
        private enum ButtonGestureState {
            case inactive
            case pressing
            case outOfBounds

            var isPressed: Bool {
                switch self {
                case .pressing:
                    return true
                default:
                    return false
                }
            }
        }

        @Environment(\.isEnabled) var isEnabled
        @EnvironmentObject var haptics: HapticEngine
        @EnvironmentObject var volume: VolumeObserver

        @GestureState private var dragState = ButtonGestureState.inactive
        @State private var isPressed = false
        @State private var isOutOfBounds: Bool = false

        let configuration: NeumorphicPrimitveButton.Configuration
        let shape: S

        var body: some View {
            let dragGesture = DragGesture(minimumDistance: 0)
                .updating($dragState, body: { value, state, transaction in
                    let distance = sqrt(
                        abs(value.translation.height) + abs(value.translation.width)
                    )
                    
                    if distance > 10 {
                        state = .outOfBounds
                    } else {
                        state = .pressing
                    }
                })
                .onChanged { _ in
                    if self.isPressed != self.dragState.isPressed {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            self.isPressed = self.dragState.isPressed
                        }
                        let depress = HapticEngine.FeedbackParameter().setAudioParameters(volume: self.volume.level, audioResource: self.haptics.audioResources["hardClick"])
                        let error = [
                            HapticEngine.FeedbackParameter().setHapticsParameters(intensity: 0.75, sharpness: 0.75).setAudioParameters(volume: self.volume.level*0.75, audioResource: self.haptics.audioResources["softClick"]).setTimeParameters(delay: 0),
                            HapticEngine.FeedbackParameter().setHapticsParameters(intensity: 0.75, sharpness: 0.75).setAudioParameters(volume: self.volume.level*0.75).setTimeParameters(delay: 0.15)
                        ]
                        self.isPressed ? self.haptics.fire(with: depress) : self.haptics.fire(with: error)
                        self.configuration.trigger()
                    }
                    
                    if self.dragState == .outOfBounds {
                        self.isOutOfBounds = true
                    } else {
                        self.isOutOfBounds = false
                    }
                }
                .onEnded { _ in
                    if self.dragState == .inactive, !self.isOutOfBounds {
                        let release = HapticEngine.FeedbackParameter().setHapticsParameters(intensity: 0.5, sharpness: 0.5).setAudioParameters(volume: self.volume.level*0.75, audioResource: self.haptics.audioResources["softClick"])
                        self.haptics.fire(with: release)
                    }
                    withAnimation(.easeOut(duration: 0.15)) {
                        self.isPressed = self.dragState.isPressed
                    }
                }

            return configuration
                .label
                .padding(30)
                .contentShape(shape)
                .foregroundColor(isEnabled ? .blue : .gray)
                .background(NeumorphicBackground(shape: shape, isHighlighted: isPressed))
                .gesture(dragGesture)
        }
    }
}
