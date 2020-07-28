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
    /// The list of candidate values a cell may contain.
    @Published var candidates: Candidates
    /// The location data for the cell. Data is separated into three categories: row, column, and region.
    @Published var location: Location
    /// Data regarding the frame of the cell within its view.
    @Published var frame: Frame = Frame()
    
    // MARK: Stored Properties
    /// Flag for whether the cell controls view focus.
    var inFocus: Bool = false
    /// Stores the state of the cell.
    /// The state controls view behavior and functionality.
    var state: State?
    
    // MARK: Initializers
    // private initializer allows control over all stored properties
    private init(state: State?, value: Value?, candidates: Candidates, location: Location) {
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
    init(value: Int, row: Int, column: Int, local: Coordinate) {
        let global = Coordinate(row, column)
        self.value = Value(value, state: .given)
        self.candidates = Candidates()
        self.location = Location(global: global, local: local)
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
    }
}

// MARK: Encapsulated Types
extension Cell {
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
        /// A state of a cell with a correct value.
        case correct
        /// A state of a cell with an incorrect value.
        case incorrect
    }
}

// MARK: Computed Properties
extension Cell {
    /// The global row position of the cell
    var row: Int { location.global.row }
    /// The global column position of the cell
    var column: Int { location.global.column }
    /// The region coordinates of the cell
    var region: Coordinate { location.local }
    
    /// The background color of the cell.
    var color: Color {
        switch state {
        case .correct:
            return Color.green.opacity(0.1)
        case .incorrect:
            return Color.red.opacity(0.1)
        default:
            return .clear
        }
    }
}

// MARK: Instance Methods
extension Cell {
    /// Sets the given value if the current value is different, otherwise it removes the value.
    /// - Parameter value: The value to modify.
    func modify(value: Int) {
        candidates = Set<Value>()
        if self.value?.rawValue != value {
            self.value = Value(value, state: .value)
        } else {
            self.value = nil
        }
    }
    
    // Sets the given candidate if the current value is different, otherwise it removes the value.
    /// - Parameter candidate: The value to modify.
    func modify(candidate: Int, state: Value.State) {
        value = nil
        let candidate = Value(candidate, state: state)
        guard let _ = candidates.get(value: candidate) else {
            candidates.remove(candidate)
            candidates.insert(candidate)
            return
        }
        candidates.remove(candidate)
    }
}

// MARK: Hashable Protocol Conformance
extension Cell.Location: Hashable {
    static func == (lhs: Cell.Location, rhs: Cell.Location) -> Bool {
        return lhs.global == rhs.global && lhs.local == rhs.local
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(global)
        hasher.combine(local)
    }
}
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
extension Cell: Hashable {
    public static func == (lhs: Cell, rhs: Cell) -> Bool {
        return lhs.location == rhs.location && lhs.value == rhs.value && lhs.candidates == rhs.candidates
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(location)
        hasher.combine(value)
        hasher.combine(candidates)
    }
}

// MARK: Codable Protocol Conformance
extension Cell.Location: Codable { }
extension Cell: Codable {
    private enum CodingKeys: String, CodingKey {
        case value
        case candidates
        case state
        case location
    }
    
    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let value = try container.decode(Value?.self, forKey: .value)
        let candidates = try container.decode(Candidates.self, forKey: .candidates)
        let location = try container.decode(Location.self, forKey: .location)
        let state = try container.decode(State.self, forKey: .state)
        self.init(state: state, value: value, candidates: candidates, location: location)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.value, forKey: .value)
        try container.encode(self.candidates, forKey: .candidates)
        try container.encode(self.location, forKey: .location)
        try container.encode(self.state, forKey: .state)
    }
}
