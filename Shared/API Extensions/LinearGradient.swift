//
//  LinearGradient.swift
//  Sudogu
//
//  Created by Vijay Iyer on 7/25/20.
//

import SwiftUI

// MARK: LinearGradient
extension LinearGradient {
    
    // MARK: Initializers
    /// Initializes a `LinearGradient` from variadic arguments of type `Color`.
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}
