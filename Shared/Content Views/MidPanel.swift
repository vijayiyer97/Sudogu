//
//  MidPanel.swift
//  Sudogu
//
//  Created by Vijay Iyer on 7/27/20.
//

import SwiftUI

struct MidPanel: View {
    @EnvironmentObject var ui: UserInterface
    
    var body: some View {
        buttons
    }
    
    private var buttons: some View {
        GeometryReader { proxy in
            HStack(alignment: .center) {
                Spacer()
                Button(action: {
                    ui.editMode = .values
                }) {
                    Image(systemName: "pencil.tip")
                        .font(.system(size: 50, weight: .thin))
                        .foregroundColor(.text)
                        .frame(width: proxy.size.width/6, height: proxy.size.width/6)
                }
                .buttonStyle(NeumorphicPrimitveButton(shape: RoundedRectangle(cornerRadius: 15)))
                Button(action: {
                    ui.editMode = .notes
                }) {
                    Image(systemName: "pencil")
                        .font(.system(size: 50, weight: .thin))
                        .foregroundColor(.text)
                        .frame(width: proxy.size.width/6, height: proxy.size.width/6)
                }
                .buttonStyle(NeumorphicPrimitveButton(shape: RoundedRectangle(cornerRadius: 15)))
                Button(action: {
                    ui.editMode = .focusedNotes
                }) {
                    Image(systemName: "pencil")
                        .font(.system(size: 50, weight: .thin))
                        .foregroundColor(.blue)
                        .frame(width: proxy.size.width/6, height: proxy.size.width/6)
                }
                .buttonStyle(NeumorphicPrimitveButton(shape: RoundedRectangle(cornerRadius: 15)))
                Button(action: {
                    ui.editMode = .nullifiedNotes
                }) {
                    Image(systemName: "pencil.slash")
                        .font(.system(size: 50, weight: .thin))
                        .foregroundColor(.lightGray)
                        .frame(width: proxy.size.width/6, height: proxy.size.width/6)
                }
                .buttonStyle(NeumorphicPrimitveButton(shape: RoundedRectangle(cornerRadius: 15)))
                Spacer()
            }
        }
        .frame(height: 75)
    }
}

struct MidPanel_Previews: PreviewProvider {
    static var previews: some View {
        MidPanel()
    }
}
