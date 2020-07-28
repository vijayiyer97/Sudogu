//
//  NumberView.swift
//  Sudogu
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
    
    /// Foreground opacity
    private var opacity: Double? {
        guard let value = value else { return nil }
        switch value.state {
        case .value:
            return 0.5
//        case .null:
//            return 0.8
        default:
            return 1
        }
    }
    
    var body: some View {
        if let value = value {
            Text(String(describing: value))
                .font(.system(size: 50, weight: .medium, design: .rounded))
                .opacity(opacity ?? 1)
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
