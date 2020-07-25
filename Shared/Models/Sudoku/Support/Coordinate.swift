//
//  Coordinate.swift
//  Shared
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

// MARK: Hashable Protocol Conformance
extension Coordinate: Hashable { }

// MARK: Codable Protocol Conformance
extension Coordinate: Codable { }
