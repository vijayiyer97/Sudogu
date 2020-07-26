//
//  MultiGestureButton.swift
//  Sudogu
//
//  Created by Vijay Iyer on 7/25/20.
//

import SwiftUI

/**
 A button that supports the multiple exclusive gestures.
 */
struct MultiGestureButton<S: Shape>: PrimitiveButtonStyle {
    private let shape: S
    private let doubleTapAction: () -> Void

    func makeBody(configuration: Self.Configuration) -> some View {
        ButtonView(configuration: configuration, shape: shape, doubleTapAction: doubleTapAction)
    }
    
    public init(shape: S, doubleTapAction: @escaping () -> Void = { }) {
        self.shape = shape
        self.doubleTapAction = doubleTapAction
    }

}

private extension MultiGestureButton {
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

        @Environment(\.colorScheme) var scheme
        @Environment(\.isEnabled) var isEnabled

        @GestureState private var dragState = ButtonGestureState.inactive
        @State private var isPressed = false

        let configuration: MultiGestureButton.Configuration
        let shape: S
        let doubleTapAction: () -> Void
        
        private var highlightColor: Color {
            switch scheme {
            case .light:
                return Color.black.opacity(0.5)
            case .dark:
                return Color.white.opacity(0.5)
            default:
                return Color.black.opacity(0.5)
            }
        }
        
        private var foregroundColor: Color {
            if isEnabled {
                if isPressed {
                    return highlightColor
                }
                return .blue
            }
            return .gray
        }

        var body: some View {
            let singleTapGesture = TapGesture()
                .onEnded {
                    self.configuration.trigger()
                }
            
            let doubleTapGesture = TapGesture(count: 2)
                .onEnded {
                    self.doubleTapAction()
                }

            return configuration
                .label
                .contentShape(shape)
                .foregroundColor(foregroundColor)
                .gesture(doubleTapGesture)
                .gesture(singleTapGesture)
        }
    }
}
