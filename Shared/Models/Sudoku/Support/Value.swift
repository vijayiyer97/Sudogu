//
//  Value.swift
//  Sudogu
//
//  Created by Vijay Iyer on 7/24/20.
//  Copyright © 2020 Vijay Iyer. All rights reserved.
//

import SwiftUI

// MARK: Value
/**
 A value of a traditional sudoku
 
 A `Value` wraps the integer representation of a sudoku into a type with a descriptive state.
 The states conform to the `Value.State` enumerated type.
 */
struct Value {
    
    // MARK: Stored Properites
    /// The raw `Int` value stored in this `Value`.
    var rawValue: Int
    /// The state of the this `Value` in gameplay.
    /// The state controls view behavior and functionality.
    var state: State
    
    // MARK: Initializers
    /// Initializes a `Value` from a raw value and state.
    /// - Parameter value: The value of the wrapper.
    /// - Parameter state: The state of the wrapper.
    init(_ value: Int = 0, state: Self.State = .given) {
        rawValue = value
        self.state = state
    }
}

// MARK: Encapsulated Types
extension Value {
    /**
     Enumerates the states of the value.
     */
    enum State: String, CaseIterable {
        /// The default state.
        static let `default`: State = .value
        
        /// A state of a user value
        case value
        /// A state of a user note
        case note
        /// A state of a known value.
        case given
        /// A state of a artificially solved value.
        case solved
        /// A state of a highlighted note.
        case focused
        /// A state of a nullified note.
        case null
    }
}
// MARK: Computed Properties
extension Value {
    /// The foreground color assigned to the value.
    var color: Color {
        switch state {
        case .value:
            return .text
        case .note:
            return .text
        case .given:
            return .text
        case .solved:
            return .red
        case .focused:
            return .blue
        case .null:
            return .lightGray
        }
    }
}

// MARK: Codable Protocol Conformance
extension Value.State: Codable {
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
extension Value: Codable {
    private enum CodingKeys: String, CodingKey {
        case rawValue
        case state
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        let state = try container.decode(State.self, forKey: .state)
        self.init(rawValue, state: state)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.rawValue, forKey: .rawValue)
        try container.encode(self.state, forKey: .state)
    }
}

// MARK: Hashable Protocol Conformance
extension Value: Hashable {
    static func ==(lhs: Value, rhs: Value) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

//// MARK: Comparable Protocol Conformance
//extension Value: Strideable {
//    typealias Stride = Int
//    
//    func distance(to other: Value) -> Stride {
//        return other.rawValue - self.rawValue
//    }
//    
//    func advanced(by n: Stride) -> Value {
//        return Value(self.rawValue + n, state: self.state)
//    }
//}

// MARK: CustomStringConvertible Protocol Conformance
extension Value: CustomStringConvertible {
    var description: String {
        return "\(rawValue)"
    }
}
