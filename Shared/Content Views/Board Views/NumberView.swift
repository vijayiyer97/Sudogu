//
//  NumberView.swift
//  Shared
//
//  Created by Vijay Iyer on 7/25/20.
//

import SwiftUI

struct NumberView: View {
    /// Optionally stores a number to display.
    var value: Value?
    /// Scale factor of the text
    var scale: CGFloat = 1
    
    /// Color for foreground.
    private var foregroundColor: Color? {
        value?.color
    }
    
    var body: some View {
        if let value = value {
            Text(String(describing: value))
                .font(.system(size: 30, weight: .medium, design: .rounded))
                .scaleEffect(scale)
                .foregroundColor(foregroundColor ?? .text)
        }
    }
}

struct NumberView_Previews: PreviewProvider {
    static var previews: some View {
        NumberView(value: Value(1, state: .default))
    }
}
