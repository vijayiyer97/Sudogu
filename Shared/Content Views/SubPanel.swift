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
        primaryButtons
    }
    
    private var primaryButtons: some View {
        VStack(spacing: 0) {
            ForEach(0..<sudoku.dimensions.rows) { row in
                HStack(spacing: 0) {
                    ForEach(0..<sudoku.dimensions.columns) { col in
                        GeometryReader { proxy in
                            NumericButton(proxy: proxy, i: row, j: col, action: toggleAction)
                        }
                    }
                }
            }
        }
        .scaledToFit()
    }
    
    private func toggleAction(value: Value) {
//        if let selection = ui.selection {
//
//        }
    }
}

struct NumericButton: View {
    @EnvironmentObject var sudoku: Sudoku
    
    var proxy: GeometryProxy
    
    var i: Int
    var j: Int
        
    var action: (Value) -> Void
    
    private let constant: CGFloat = 30
    private var number: Value {
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
                    .fixedSize()
                    .frame(width: proxy.size.width-constant, height: proxy.size.height-constant)
            }
        }
        .frame(width: proxy.size.width, height: proxy.size.height)
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

