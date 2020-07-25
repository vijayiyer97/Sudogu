//
//  Dimensions.swift
//  Shared
//
//  Created by Vijay Iyer on 7/24/20.
//  Copyright © 2020 Vijay Iyer. All rights reserved.
//

// MARK: Dimensions
/**
 Dimensions of a sudoku box. Specifies the number of rows and columns.
 */
struct Dimensions {
    
    // MARK: Stored properties
    /// Region dimension, constrained by `Dimensions.Bounds`.
    let rows, columns: Int
    
    // MARK: Initializers
    
    /// Initializes the dimensions.
    /// - Parameter rows: Number of rows in a box (range `2...5`).
    /// - Parameter columns: Number of columns in a box (range `2...5`).
    ///
    /// The number of cells should be in the range `4 ..<25`.
    /// Fails if the dimensions are outside the Bounds ranges.
    init?(rows: Int, columns: Int) {
        guard Bounds.rows.contains(rows), Bounds.columns.contains(columns), rows * columns <= Bounds.maxCells else { return nil }
        self.rows = rows
        self.columns = columns
    }
    
}

// MARK: Encapsulated Types
/// Specifies lower and upper bounds for the number of rows and number of columns in a box.
/// Minimum = 2, maximum = 5.
extension Dimensions {
    enum Bounds {
        // MARK: Static Properties
        private static let max = 5 // The maximum value
        private static let min = 2 // The minimum value
        /// Range of the allowed number of columns in a box.
        static let columns = min...max
        /// Range of the allowed number of rows in a box.
        static let rows = min...max
        /// Maximum number of cells in a box.
        static let maxCells = max*max
    }
}

// MARK: Static Properties
extension Dimensions {
    static let `default`: Dimensions = Dimensions(rows: 3, columns: 3)!
}

// MARK: Computed Properties
extension Dimensions {
    /// The number of cells in a region = rows * columns.
    var cells: Int {
        rows * columns
    }
}

// MARK: Hashable Protocol Conformance
extension Dimensions: Hashable { }

// MARK: Codable Protocol Conformance
extension Dimensions: Codable { }
