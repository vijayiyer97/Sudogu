//
//  Set.swift
//  Sudogu
//
//  Created by Vijay Iyer on 7/25/20.
//

// MARK: Set
extension Set where Set.Element == Value {
    /// Retrieves an element from the set if it exists, else returns `nil`.
    func get(value: Int) -> Value? {
        guard let index = firstIndex(of: Value(value)) else { return nil }
        
        return self[index]
    }
    
    func get(value: Value) -> Value? {
        guard let index = firstIndex(of: value) else { return nil }
        
        let newValue = self[index]
        guard newValue.state == value.state else { return nil }
        
        return newValue
    }
}
