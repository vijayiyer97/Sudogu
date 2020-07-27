//
//  MainPanel.swift
//  Sudogu
//
//  Created by Vijay Iyer on 7/25/20.
//

import SwiftUI

struct MainPanel: View {
    @EnvironmentObject var sudoku: Sudoku
    
    var body: some View {
        board
    }
    
    private var board: some View {
        ZStack {
            GeometryReader { proxy in
                BoardView()
                .onAppear {
                    // set sudoku frame parameters so that the zoom and drag features will work properly.
                    let frame = proxy.frame(in: .named("Sudoku"))
                    let center = CGPoint(x: frame.midX, y: frame.midY)
                    
                    sudoku.frame.width = frame.width
                    sudoku.frame.height = frame.height
                    sudoku.frame.center = center
                    
                    sudoku.frame.offset.max = CGSize(width: proxy.size.width*0.5, height: proxy.size.height*0.5)
                    sudoku.frame.offset.min = CGSize(width: -proxy.size.width*0.5, height: -proxy.size.height*0.5)
                    
                    sudoku.frame.scale.max = CGFloat(sudoku.size/3)
                    sudoku.frame.scale.min = 0.95
                    
                    sudoku.frame.scale.value = 0.95
                    
                }
                .mask(
                    Rectangle()
                        .foregroundColor(.none)
                        .cornerRadius(25)
                )
            }
        }
        .aspectRatio(1, contentMode: .fill)
//        .scaleEffect(0.8)
        .coordinateSpace(name: "Sudoku")
    }
}
