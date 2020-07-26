//
//  CGPoint.swift
//  Sudogu
//
//  Created by Vijay Iyer on 7/25/20.
//

import CoreGraphics

// MARK: CGPoint

// MARK: Operator Overloads
extension CGPoint {
    public static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        let x = lhs.x + rhs.x
        let y = lhs.y + rhs.y
        return CGPoint(x: x, y: y)
    }
    
    public static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        let x = lhs.x - rhs.x
        let y = lhs.y - rhs.y
        return CGPoint(x: x, y: y)
    }
}
