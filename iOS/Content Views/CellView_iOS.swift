//
//  CellView_iOS.swift
//  Sudogu (iOS)
//
//  Created by Vijay Iyer on 7/25/20.
//

import SwiftUI

struct CellView_iOS: View {
    @EnvironmentObject var sudoku: Sudoku
    @EnvironmentObject var ui: UserInterface
    @EnvironmentObject var haptics: HapticEngine
    
    @State private var currentOffset: CGSize = .zero
    @State private var finalOffset: CGSize = .zero
    @State private var currentAmount: CGFloat = 0
    @State private var finalAmount: CGFloat = 0.95
    @ObservedObject var cell: Cell
    
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
                withAnimation {
                    toggleSelection()
                }
            }) {
                ZStack {
                    // standard views
                    if let value = cell.value {
                        Rectangle()
                            .foregroundColor(cell.color)
                            .overlay(
                                NumberView(value: value, scale: 0.5)
                                    .scaledToFill()
                            )
                    } else if cell.candidates.count != 0 {
                        Rectangle()
                            .foregroundColor(.clear)
                            .overlay(
                                NotesView(cell: cell, scale: 0.25)
                            )
                    } else {
                        Rectangle()
                            .foregroundColor(.clear)
                    }
                    // highlighted views
                    if let _ = ui.selection {
                        Rectangle()
                            .foregroundColor(.highlight)
                            .opacity(opacity)
                    }
                }
            }
            .buttonStyle(
                MultiGestureButton(shape: Rectangle()) {
                    withAnimation {
                        toggleZoom()
                    }
                }
            )
            .onAppear {
                let frame = proxy.frame(in: .named("Board"))
                cell.frame.center = CGPoint(x: frame.midX, y: frame.midY)
            }
        }
        
    }
    
    private func toggleSelection() {
        haptics.fire()
        if ui.selection == cell {
            ui.selection = nil
        } else {
            ui.selection = cell
        }
    }
    
    // toggles a cell's foucsed zoom.
    // focused zoom is when the sudoku is fully zoomed in and centered on a specific cell (the focus).
    private func toggleZoom() {
        let parameters = [
            HapticEngine.FeedbackParameter().setHapticsParameters(intensity: 0.5, sharpness: 0.5).setTimeParameters(delay: 0),
            HapticEngine.FeedbackParameter().setHapticsParameters(intensity: 0.75, sharpness: 0.75).setTimeParameters(delay: 0.15)
        ]
        haptics.fire(with: parameters)
        if ui.selection != cell || !cell.inFocus {
            let c1 = cell.frame.center
            let c2 = sudoku.frame.center
            let offset = c2 - c1

            sudoku.frame.offset.width = offset.x
            sudoku.frame.offset.height = offset.y
            sudoku.frame.scale.value = 100
            
            cell.inFocus = true
            ui.selection?.inFocus = false
            ui.selection = cell
        } else {
            cell.inFocus = false
            ui.selection = nil
            sudoku.frame.offset.width = 0
            sudoku.frame.offset.height = 0
            sudoku.frame.scale.value = 0
        }
    }
}
