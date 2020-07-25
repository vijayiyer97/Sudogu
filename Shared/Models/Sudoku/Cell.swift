//
//  Cell.swift
//  Sudogu
//
//  Created by Vijay Iyer on 7/24/20.
//  Copyright © 2020 Vijay Iyer. All rights reserved.
//

import SwiftUI

// MARK: Cell
/**
 A cell of a traditional sudoku.
 
 A cell may either be empty or contain a value within the constraints of the sudoku's constraint set.
 A cell encapsulates the following properties:
 * A representative value, either a constrained value or nil
 * A representative set of candidate values
 * The location in the global and regional sudoku coordinate spaces
 * A flag for controlling view focus
 * A descriptive state
 * The background color
 */
final class Cell: ObservableObject {
    /// A typealias for the candidate set.
    typealias Candidates = Set<Value>
    
    // MARK: Published Properties
    /// The representative value of the cell.
    /// Either a given value or `nil`.
    @Published var value: Value? {
        didSet {
            guard let _ = value else { return }
            candidates = []
        }
    }
    /// Stores the list of candidate values a cell may contain.
    @Published var candidates: Candidates
    /// Stores the location data for the cell. Data is separated into three categories: row, column, and region.
    @Published var location: Location
    /// Stores data regarding the frame of the cell within its view.
    //@Published var frame: Frame = Frame()
    
    // MARK: Stored Properties
    /// Flag for whether the cell controls view focus.
    var focused: Bool = false
    /// Stores the state of the cell.
    /// The state controls view behavior and functionality.
    var state: State
    
    // MARK: Initializers
    // private initializer allows control over all stored properties
    private init(state: State, value: Value?, candidates: Candidates, location: Location) {
        self.value = value
        self.candidates = candidates
        self.location = location
        self.state = state
    }
    
    /// Intializes a given value for a `Cell` instance.
    /// Parameters are constrained by values set in the CSP for the corresponding sudoku. For more information see [here](https://en.wikipedia.org/wiki/Exact_cover#Sudoku).
    /// - Parameter value: The `Value` representation of the encapsulated value (cell constraint).
    /// - Parameter row: The global row position of the cell (row constraint).
    /// - Parameter column: The global column position of the cell (column constraint).
    /// - Parameter local: The cooridinate position in the local system (regional constraint).
    init(value: Value, row: Int, column: Int, local: Coordinate) {
        let global = Coordinate(row, column)
        self.value = value
        self.candidates = Candidates()
        self.location = Location(global: global, local: local)
        self.state = .immutable
    }
    
    /// Initializes a given candidate set for an unsolved `Cell` instance.
    /// Parameters are constrained by values set in the CSP for the corresponding sudoku. For more information see [here](https://en.wikipedia.org/wiki/Exact_cover#Sudoku).
    /// - Parameter candidates: The value set for this `Cell` instance (cell constraint).
    /// - Parameter row: The global row position of the cell (row constraint).
    /// - Parameter column: The global column position of the cell (column constraint).
    /// - Parameter local: The cooridinate position in the local system (regional constraint).
    init(candidates: Candidates, row: Int, column: Int, local: Coordinate) {
        let global = Coordinate(row, column)
        self.value = nil
        self.candidates = candidates
        self.location = Location(global: global, local: local)
        self.state = .mutable
    }
}

// MARK: Extensions
/// Extends `Cell` with computed properties and nested structures.
extension Cell {
    
    // MARK: Nested Structures
    /**
     The location of  a `Cell` instance in terms of named coordinate systems.
     
     The location of objects in a sudoku grid is divided into two coordinate systems: the global system and the local system.
     
     The global coordinate system refers to the origin located at the top-left corner of the grid.
     
     The local coordinate system referes to the origin located at the top-left corner of the encapuslating region.
     */
    struct Location {
        /// The coordinate in the global system.
        var global: Coordinate = Coordinate()
        /// The coordinate in the local system.
        var local: Coordinate = Coordinate()
    }
    
    /**
     The descriptive state of a `Cell` instance.
     */
    enum State: String, CaseIterable {
        /// A a state of an editable cell.
        case mutable
        /// A state of an uneditable cell.
        case immutable
        /// A state of a cell with a correct value.
        case correct
        /// A state of a cell with an incorrect value.
        case incorrect
        /// A state of a highlighted cell.
        case selected
    }
    
    // MARK: Computed Properties
    /// Stores the background color of the cell.
    var color: Color {
        switch state {
        case .mutable:
            return .complementary3
        case .immutable:
            return .clear
        case .correct:
            return Color.green.opacity(0.1)
        case .incorrect:
            return Color.red.opacity(0.1)
        case .selected:
            return Color.blue.opacity(0.1)
        }
    }
}
/// Extends `Cell.Location` with computed properties and nested structures
extension Cell.Location { }
/// Extends `Cell.Location` with `Hashable` and `Codable` protocol conformance.
extension Cell.Location: Hashable, Codable {
    static func == (lhs: Cell.Location, rhs: Cell.Location) -> Bool {
        return lhs.global == rhs.global && lhs.local == rhs.local
    }
}
/// Extends `Cell.State` with `Codable` protocol conformance.
extension Cell.State: Codable {
    private enum Key: CodingKey {
        case rawValue
    }
    
    /// Encapsulates decoding errors.
    enum DecodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(String.self, forKey: .rawValue)
        guard let state = Self(rawValue: rawValue) else { throw DecodingError.unknownValue }
        self = state
    }
        
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(self.rawValue, forKey: .rawValue)
    }
}
/// Extends `Cell` with `Hashable` protocol conformance.
extension Cell: Hashable {
    static func == (lhs: Cell, rhs: Cell) -> Bool {
        return lhs.location == rhs.location && lhs.value == rhs.value && lhs.candidates == rhs.candidates
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(location)
        hasher.combine(value)
        hasher.combine(candidates)
    }
}
/// Extends `Cell` with `Codable` protocol conformance.
extension Cell: Codable {
    private enum CodingKeys: String, CodingKey {
        case value
        case candidates
        case state
        case location
    }
    
    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let value = try container.decode(Value?.self, forKey: .value)
        let candidates = try container.decode(Candidates.self, forKey: .candidates)
        let location = try container.decode(Location.self, forKey: .location)
        let state = try container.decode(State.self, forKey: .state)
        self.init(state: state, value: value, candidates: candidates, location: location)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.value, forKey: .value)
        try container.encode(self.candidates, forKey: .candidates)
        try container.encode(self.location, forKey: .location)
        try container.encode(self.state, forKey: .state)
    }
}
