//
//  NotesView.swift
//  Shared
//
//  Created by Vijay Iyer on 7/25/20.
//

import SwiftUI

struct NotesView: View {
    @EnvironmentObject var sudoku: Sudoku
    
    /// Optionally stores each note inside a fixed width array.
    var index: Int
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
        return sudoku.values[index].candidates.get(value: value)
    }
}

struct NotesView_Previews: PreviewProvider {
    static let sudoku: Sudoku = Sudoku.default
    static let index: Int = 0
    static var previews: some View {
        NotesView(index: index)
            .environmentObject(sudoku)
            .onAppear {
                sudoku.values[index] = Cell(candidates: Set(Value(1)...Value(9)), row: 0, column: 0, local: Coordinate(0, 0))
            }
    }
}
