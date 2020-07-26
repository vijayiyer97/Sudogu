//
//  Neumorphism.swift
//  Sudogu
//
//  Created by Vijay Iyer on 7/25/20.
//

import SwiftUI

struct NeumorphicBackground<S: Shape>: View {
    @Environment(\.colorScheme) var scheme

    let shape: S
    var isHighlighted: Bool = false

    var body: some View {
        ZStack {
            if scheme == .light {
                light
            } else if scheme == .dark {
                dark
            }
        }
    }

    private var light: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(Color.complementary2)
                    .overlay(shape
                                .stroke(Color.complementary3, lineWidth: 4)
                                .blur(radius: 4)
                                .offset(x: 2, y: 2)
                                .mask(shape.fill(LinearGradient(.black, .clear)))
                    )
                    .overlay(shape
                                .stroke(Color.complementary1.opacity(0.7), lineWidth: 8)
                                .blur(radius: 4)
                                .offset(x: -2, y: -2)
                                .mask(shape.fill(LinearGradient(.clear, .black)))
                    )
            } else {
                shape
                    .fill(Color.complementary2)
                    .shadow(color: Color.complementary5.opacity(0.15), radius: 10, x: 10, y: 10)
                    .shadow(color: Color.complementary1.opacity(0.7), radius: 10, x: -5, y: -5)
            }
        }
    }

    private var dark: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(LinearGradient(Color.complementary4, Color.complementary2))
                    .shadow(color: Color.complementary2.opacity(0.5), radius: 10, x: 5, y: 5)
                    .shadow(color: Color.complementary4.opacity(0.3), radius: 10, x: -5, y: -5)

            } else {
                shape
                    .fill(LinearGradient(Color.complementary2, Color.complementary4))
                    .shadow(color: Color.complementary2.opacity(0.5), radius: 10, x: -10, y: -10)
                    .shadow(color: Color.complementary4.opacity(0.7), radius: 10, x: 10, y: 10)
            }
        }
    }
}
