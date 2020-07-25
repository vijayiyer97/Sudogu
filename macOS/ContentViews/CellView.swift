//
//  CellView.swift
//  macOS
//
//  Created by Vijay Iyer on 7/25/20.
//

import SwiftUI

struct CellView: View {
    @EnvironmentObject var sudoku: Sudoku
    @EnvironmentObject var ui: UserInterface
    
    var index: Int
    
    private var cell: Cell { sudoku.values[index] }
    private var opacity: Double {
        var opacity: Double = 0
        if ui.selection?.row == cell.row { opacity += 0.1 }
        if ui.selection?.column == cell.column { opacity += 0.1 }
        if ui.selection?.region == cell.region { opacity += 0.1 }
        return opacity
    }
    
    var body: some View {
        GeometryReader { proxy in
            Button(action: {
                
            }) {
                // standard views
                if let value = cell.value {
                    Rectangle()
                        .foregroundColor(cell.color)
                        .overlay(
                            NumberView(value: value, scale: 0.75)
                        )
                } else if cell.candidates.count != 0 {
                    Rectangle()
                        .foregroundColor(cell.color)
                        .overlay(
                            NotesView(index: index, scale: 0.3)
                        )
                } else {
                    Rectangle()
                        .foregroundColor(cell.color)
                }
                // highlighted views
                if let _ = ui.selection {
                    Rectangle()
                        .foregroundColor(.highlight)
                        .opacity(opacity)
                }
            }
        }
    }
}

//struct CellView_Previews: PreviewProvider {
//    static var previews: some View {
//        CellView()
//    }
//}
