//
//  Set.swift
//  Shared
//
//  Created by Vijay Iyer on 7/25/20.
//

// MARK: Set
extension Set where Set.Element == Value {
    func get(value: Int) -> Value? {
        guard let index = firstIndex(of: Value(value)) else { return nil }
        
        return self[index]
    }
}
