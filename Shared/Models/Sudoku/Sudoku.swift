//
//  Sudoku.swift
//  Sudogu
//
//  Created by Vijay Iyer on 7/24/20.
//  Copyright © 2020 Vijay Iyer. All rights reserved.
//

import SwiftUI

// MARK: Sudoku
/**
 A traditional sudoku consisting of rows, columns and regions which encapsulate cells.
 
 Each cell may be empty or contain a number within the constraint set.
 The constraint set is based on the size of the sudoku.
 A sudoku can be examined as a constraint-satisfaction problem (see [CSP](https://en.wikipedia.org/wiki/Exact_cover#Sudoku))
 In a CSP sudoku, there are only four mandatory constraints, which are as follows:
 * A cell may only contain a single value within the constraint set
 * Every value in a row must be unique
 * Every value in a column must be unique
 * Every value in a region must be unique

 While the sudoku is a square, the regions may be rectangular.
 The sudoku size is determined by the dimensions of its regions.
 The number of regions in the sudoku is constrained by:
 * Number of horizontal regions = number of region rows.
 * Number of vertical regions = number of region columns.
 The size (number of rows OR number of columns in the sudoku) = the number of cells of the sudoku dimensions.
 The number of cells in the total sudoku = size * size.

 Example:
 * Sudoku region dimensions = 2 rows by 4 columns
 * Sudoku size = number of sudoku rows = number of sudoku columns = 8
 * Number of sudoku cells = 64
 * Each non-nil cell value must lie in the range `1...8` and be unique in the houses containing that cell.
*/
final class Sudoku: ObservableObject {
    /// A typealias for representing the sudoku board.
    typealias Board = [Cell]
    
    // MARK: Stored Properties
    /// The values of a sudoku.
    var values: Board
    /// The dimensions of a region.
    var dimensions: Dimensions
    /// The cache store.
    var cache: [Board] = []
    /// The maximum size for the cache.
    var cacheSize: Int = 25
    
    // MARK: Initializers
    /// Initializes a  `Sudoku` from another instance.
    /// - Parameter other: Another `Sudoku` instance.
    init(from other: Sudoku) {
        values = other.values
        dimensions = other.dimensions
    }
    
    /// Initializes a `Sudoku` from a given board and dimensions.
    /// - Parameter values: The board of the sudoku.
    /// - Parameter dimensions: The dimensions of the sudoku regions.
    init?(values: [[Int?]], dimensions: Dimensions) {
        // validate input dimensions.
        let size = dimensions.cells, rows = dimensions.rows
        guard values.count == size else { return nil }
        
        for row in values {
            guard row.count == size else { return nil }
        }
        var rowValues = [Set<Int>](repeating: Set<Int>(), count: size)
        var columnValues = [Set<Int>](repeating: Set<Int>(), count: size)
        var regionValues = [Set<Int>](repeating: Set<Int>(), count: size)
        
        var cells = Board()
        for row in 0..<size{
            for col in 0..<size {
                let cell: Cell
                let region = Coordinate(row/dimensions.rows, col/dimensions.columns)
                if let value = values[row][col] {
                    guard (1...size).contains(value), rowValues[row].insert(value).inserted, columnValues[col].insert(value).inserted, regionValues[region.row * rows + region.column].insert(value).inserted else { return nil }
                    cell = Cell(value: Value(value), row: row, column: col, local: region)
                } else {
                    cell = Cell(candidates: Cell.Candidates(), row: row, column: col, local: region)
                }
                cells.append(cell)
            }
        }
        
        self.dimensions = dimensions
        self.values = cells
    }
    
    /// Initializes a `Sudoku` from a given board and dimensions.
    /// - Parameter values: The board of the sudoku.
    /// - Parameter rows: The rows in a region.
    /// - Parameter columns: The columns in a region.
    convenience init?(values: [[Int?]], rows: Int = 3, columns: Int = 3) {
        guard let dimensions = Dimensions(rows: rows, columns: columns) else { return nil }
        self.init(values: values, dimensions: dimensions)
    }
    
}

// MARK: Extensions
/// Extends `Sudoku` with static properties.
extension Sudoku {
    /// The default `Sudoku` to load.
    static let `default`: Sudoku = Sudoku(values: [
        [ 5 , 3 , 4 ,   nil,nil, 8 ,    nil, 1 ,nil],
        [nil,nil,nil,   nil,nil, 2 ,    nil, 9 ,nil],
        [nil,nil,nil,   nil,nil, 7 ,     6 ,nil, 4 ],
        
        [nil,nil,nil,    5 ,nil,nil,     1 ,nil,nil],
        [ 1 ,nil,nil,   nil,nil,nil,    nil,nil, 3 ],
        [nil,nil, 9,    nil,nil, 1 ,    nil,nil,nil],
        
        [ 3 ,nil, 5 ,    4 ,nil,nil,    nil,nil,nil],
        [nil, 8 ,nil,    2 ,nil,nil,    nil,nil,nil],
        [nil, 6 ,nil,    7 ,nil,nil,     3 , 8 , 2 ],
    ], dimensions: Dimensions.default)!
    /// The file name for encoding and decoding `Sodoku`.
    static let file: String = "sudogu.json"
}
/// Extends `Sudoku` with computed properties and nested structures.
extension Sudoku {
    // MARK: Computed Properties
    /// The size of the sudoku.
    var size: Int { dimensions.cells }
    /// The number of cells contained in the sudoku.
    var cells: Int { size * size }
}

// MARK: Codable Conformance

enum CodingKeys: String, CodingKey {
    case values
    case dimensions
}

extension Sudoku: Hashable {
    public static func == (lhs: Sudoku, rhs: Sudoku) -> Bool {
        return lhs.values == rhs.values && lhs.dimensions == rhs.dimensions
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(values)
        hasher.combine(dimensions)
    }
}
