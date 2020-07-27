//
//  BoardView.swift
//  Sudogu
//
//  Created by Vijay Iyer on 7/25/20.
//

import SwiftUI

struct BoardView: View {
    @EnvironmentObject var sudoku: Sudoku
    @State private var currentOffset: CGSize = .zero
    @State private var finalOffset: CGSize = .zero
    @State private var currentAmount: CGFloat = 0
    @State private var finalAmount: CGFloat = 0.9
    
    var body: some View {
        // allows a user to drag the sudoku around.
        let dragGesture = DragGesture(coordinateSpace: .local)
            .onChanged { value in
                if self.currentOffset == .zero && self.sudoku.frame.offset.width != self.finalOffset.width && self.sudoku.frame.offset.height == self.finalOffset.height {
                    self.finalOffset.width = self.sudoku.frame.offset.width
                    self.finalOffset.height = self.sudoku.frame.offset.height
                }
                self.currentOffset = value.translation
                
                withAnimation {
                    self.sudoku.frame.offset.width = self.currentOffset.width + self.finalOffset.width
                    self.sudoku.frame.offset.height = self.currentOffset.height + self.finalOffset.height
                }
            }
            .onEnded { value in
                var predictiveOffset = self.currentOffset
                let width = value.predictedEndTranslation.width - value.translation.width
                let height = value.predictedEndTranslation.height - value.translation.height

                predictiveOffset.width += width/3
                predictiveOffset.height += height/3
                self.finalOffset.width += predictiveOffset.width
                self.finalOffset.height += predictiveOffset.height
                self.currentOffset = .zero

                withAnimation {
                    self.sudoku.frame.offset.width = self.finalOffset.width
                    self.sudoku.frame.offset.height = self.finalOffset.height
                }
            }
        
        // allows the user to zoom into the sudoku.
        let magnificationGesture = MagnificationGesture()
            .onChanged { value in
                self.currentAmount = value - 1
                
                if self.currentAmount < 0 {
                    self.sudoku.frame.offset.width *= value
                    self.sudoku.frame.offset.height *= value
                } else {
                    
                }
                
                let scale = self.finalAmount + self.currentAmount
                
                withAnimation {
                    self.sudoku.frame.scale.value = scale
                }
            }
            .onEnded { _ in
                withAnimation {
                    self.finalAmount += self.currentAmount
                    self.currentAmount = 0
                }
            }
        
        let exclusiveGesture = SimultaneousGesture(magnificationGesture, dragGesture)
        
        return contents
            .border(Color.border, width: 3)
            .aspectRatio(1, contentMode: .fit)
            .offset(x: sudoku.frame.offset.width, y: sudoku.frame.offset.height)
            .scaleEffect(sudoku.frame.scale.value)
            .highPriorityGesture(exclusiveGesture)
            .drawingGroup()
    }

    private var contents: some View {
        VStack(spacing: 0) {
            ForEach(0..<sudoku.size) { i in
                HStack(spacing: 0) {
                    ForEach(0..<sudoku.size) { j in
                        CellView(index: i*sudoku.size + j)
                            .border(Color.border, width: 0.75)
                            .border(width: getBorder(sudoku[i][j].column, sudoku.dimensions.columns), edge: .leading, color: .black)
                            .border(width: getBorder(sudoku[i][j].row, sudoku.dimensions.rows), edge: .top, color: .black)

                    }
                }
            }
        }
        .coordinateSpace(name: "Board")
    }

    private func getBorder(_ location: Int, _ mod: Int) -> CGFloat {
        location % mod == 0 ? 2 : 0
    }
}

struct BoardView_Previews: PreviewProvider {
    static let sudoku: Sudoku = Sudoku.shared
    static let ui: UserInterface = UserInterface()
    
    static var previews: some View {
        BoardView()
            .environmentObject(sudoku)
            .environmentObject(ui)
    }
}
