//
//  Coordinate.swift
//  Sudogu
//
//  Created by Vijay Iyer on 7/24/20.
//  Copyright © 2020 Vijay Iyer. All rights reserved.
//

// MARK: Coordinate
/**
 Wraps a coordinate in a two-dimensional plane of integers.
 */
struct Coordinate {
    
    // MARK: Stored Properties
    /// The y-coordinate of the object.
    var row: Int
    /// The x-coordinate of the object.
    var column: Int
    
    // MARK: Initializers
    init(_ row: Int = 0, _ column: Int = 0) {
        self.row = row
        self.column = column
    }
}


/// Extends `Coordinate` with computed properties and nested structures.
extension Coordinate { }
/// Extends `Value` with `Hashable` and `Codable` protocol conformance.
extension Coordinate: Hashable, Codable { }
