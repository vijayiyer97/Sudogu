//
//  CellView.swift
//  Sudogu
//
//  Created by Vijay Iyer on 7/25/20.
//

import SwiftUI

struct CellView: View {
    var index: Int
    
    var body: some View {
        #if os(iOS)
        CellView_iOS(index: index)
        #elseif os(macOS)
        CellView_macOS()
        #endif
    }
}

struct CellView_Previews: PreviewProvider {
    static let sudoku: Sudoku = Sudoku.shared
    static let ui: UserInterface = UserInterface()
    static let index: Int = 0
    static var previews: some View {
        CellView(index: index)
            .environmentObject(sudoku)
            .environmentObject(ui)
            .onAppear {
                sudoku.values[index].state = .immutable
            }
    }
}
