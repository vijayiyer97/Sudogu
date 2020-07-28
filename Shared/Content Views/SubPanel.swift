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
        buttons
    }
    
    private var buttons: some View {
        VStack(spacing: 0) {
            ForEach(0..<sudoku.dimensions.rows) { row in
                HStack(spacing: 0) {
                    ForEach(0..<sudoku.dimensions.columns) { col in
                        GeometryReader { proxy in
                            NumericButton(proxy: proxy, i: row, j: col, action: toggleAction)
                                .frame(width: proxy.size.width, height: proxy.size.width, alignment: .center)
                        }
                        .scaledToFit()
                        
                    }
                }
            }
        }
    }
    
    private func toggleAction(value: Int) {
        if let selection = ui.selection, selection.value?.state != .given {
            withAnimation {
                switch ui.editMode {
                case .values:
                    selection.modify(value: value)
                case .notes:
                    selection.modify(candidate: value, state: .note)
                case .focusedNotes:
                    selection.modify(candidate: value, state: .focused)
                case .nullifiedNotes:
                    selection.modify(candidate: value, state: .null)
                }
            }
        }
    }
}

struct NumericButton: View {
    @EnvironmentObject var sudoku: Sudoku
    
    var proxy: GeometryProxy
    
    var i: Int
    var j: Int
        
    var action: (Int) -> Void
    
    private let constant: CGFloat = 30
    private var number: Value {
        Value(sudoku.dimensions.rows*i + j + 1)
    }
    
    var body: some View {
        Button(action: {
            withAnimation {
                action(number.rawValue)
            }
        }) {
            ZStack {
                NumberView(value: number)
                    .frame(width: proxy.size.width-constant, height: proxy.size.width-constant)
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
        VStack {
            Spacer()
            SubPanel()
                .environmentObject(sudoku)
                .environmentObject(ui)
            Spacer()
        }
    }
}

