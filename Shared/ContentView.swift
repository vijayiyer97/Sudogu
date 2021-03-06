//
//  ContentView.swift
//  Sudogu
//
//  Created by Vijay Iyer on 7/25/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        #if os(iOS)
        iOS_View()
        #elseif os(macOS)
        macOS_View()
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static let sudoku: Sudoku = Sudoku.shared
    static let ui: UserInterface = UserInterface()
    
    static var previews: some View {
        ContentView()
            .environmentObject(sudoku)
            .environmentObject(ui)
    }
}
