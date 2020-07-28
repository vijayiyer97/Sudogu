//
//  CellView.swift
//  Sudogu
//
//  Created by Vijay Iyer on 7/25/20.
//

import SwiftUI

struct CellView: View {
    @EnvironmentObject var sudoku: Sudoku
    
    var index: Int
    
    var body: some View {
        #if os(iOS)
        CellView_iOS(cell: sudoku.values[index])
        #elseif os(macOS)
        CellView_macOS()
        #endif
    }
}
