//
//  UserInterface.swift
//  Sudogu
//
//  Created by Vijay Iyer on 7/25/20.
//

import SwiftUI

// MARK: Inteface
final class UserInterface: ObservableObject {
    // MARK: Published Properties
    /// The cell selected within the view.
    @Published var cell: Cell?
    /// The write mode of the app
}
