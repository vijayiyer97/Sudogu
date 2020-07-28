//
//  iOS_View.swift
//  Sudogu (iOS)
//
//  Created by Vijay Iyer on 7/25/20.
//

import SwiftUI

struct iOS_View: View {
    @EnvironmentObject var sudoku: Sudoku
    @EnvironmentObject var ui: UserInterface
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 0) {
                MainPanel()
                MidPanel()
                SubPanel()
                    .scaleEffect(1)
            }
            .navigationBarHidden(true)
            .background(background)
        }
    }
    
    private var background: some View {
        NeumorphicBackground(shape: Rectangle())
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                withAnimation {
                    ui.selection = nil
                }
            }
    }
}

struct iOS_View_Previews: PreviewProvider {
    static let sudoku: Sudoku = Sudoku.shared
    static let ui: UserInterface = UserInterface()
    
    static var previews: some View {
        iOS_View()
            .environmentObject(sudoku)
            .environmentObject(ui)
    }
}
