//
//  NotesView.swift
//  Sudogu
//
//  Created by Vijay Iyer on 7/25/20.
//

import SwiftUI

struct NotesView: View {
    @EnvironmentObject var sudoku: Sudoku
    
    /// Optionally stores each note inside a fixed width array.
    @ObservedObject var cell: Cell
    /// Scales the number views within.
    var scale: CGFloat = 1
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<sudoku.dimensions.rows) { i in
                HStack(spacing: 0) {
                    ForEach(0..<sudoku.dimensions.columns) { j in
                        Rectangle()
                        .foregroundColor(.clear)
                        .overlay(
                            NumberView(value: self.getValue(value: self.sudoku.dimensions.rows*i + j + 1), scale: self.scale)
                            .scaledToFill()
                        )
                    }
                }
            }
        }
    }
    
    private func getValue(value: Int) -> Value? {
        return cell.candidates.get(value: value)
    }
}
