//
//  SubPanel.swift
//  Sudogu
//
//  Created by Vijay Iyer on 7/25/20.
//

import SwiftUI

struct SubPanel: View {
    @EnvironmentObject var sudoku: Sudoku
    @EnvironmentObject var ui: UserInterface
    
    var body: some View {
        buttonsView
    }
    
    private var buttonsView: some View {
        VStack(spacing: 0) {
            ForEach(0..<sudoku.dimensions.rows) { row in
                HStack(spacing: 0) {
                    ForEach(0..<sudoku.dimensions.columns) { col in
                        NumericButton(i: row, j: col, action: toggleAction)
                            .padding(.horizontal, 20)
                    }
                }
            }
        }
        .scaledToFit()
    }
    
    private func toggleAction(value: Value) {
        
    }
}

struct NumericButton: View {
    @EnvironmentObject var sudoku: Sudoku
    
    var i: Int
    var j: Int
        
    var action: (Value) -> Void
    
    var number: Value {
        Value(sudoku.dimensions.rows*i + j + 1)
    }
    
    var body: some View {
        Button(action: {
            withAnimation {
                action(number)
            }
        }) {
            ZStack {
                NumberView(value: number)
                    .scaledToFill()
            }
        }
        .buttonStyle(NeumorphicPrimitveButton(shape: Circle()))
    }
}

struct SubPanel_Previews: PreviewProvider {
    static let sudoku: Sudoku = Sudoku.shared
    static let ui: UserInterface = UserInterface()
    
    static var previews: some View {
        SubPanel()
            .environmentObject(sudoku)
            .environmentObject(ui)
    }
}

