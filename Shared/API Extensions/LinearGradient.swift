//
//  LinearGradient.swift
//  Shared
//
//  Created by Vijay Iyer on 7/25/20.
//

import SwiftUI

// MARK: LinearGradient
extension LinearGradient {
    
    // MARK: Initializers
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}
