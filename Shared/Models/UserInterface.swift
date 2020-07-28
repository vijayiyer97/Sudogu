//
//  UserInterface.swift
//  Sudogu
//
//  Created by Vijay Iyer on 7/25/20.
//

import SwiftUI

// MARK: UseerInteface
final class UserInterface: ObservableObject {
    // MARK: Published Properties
    /// The cell selected within the view.
    @Published var selection: Cell?
    /// The write mode of the app
    @Published var editMode: State = .default
}

// MARK: Encapsulated Types
extension UserInterface {
    enum State {
        static let `default`: State = .values
        
        case values
        case notes
        case focusedNotes
        case nullifiedNotes
    }
}
