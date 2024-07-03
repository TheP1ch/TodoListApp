//
//  ColorCell.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 03.07.2024.
//

import SwiftUI

struct ColorCell: View {
    //MARK: Public Properties
    
    @Binding var itemColor: Color
    
    @State var newColor: Color
    
    @Binding var hasColor: Bool
    
    //MARK: Private Properties
    @State private var isColorPickerOpen = false
    
    //MARK: Body
    var body: some View {
        Toggle(isOn: $hasColor) {
            VStack(alignment: .leading) {
                Text("Цвет")
                    .font(AppFont.body.font)
                    .foregroundStyle(ColorTheme.Label.labelPrimary.color)
                
                
                if hasColor {
                    Button {
                        isColorPickerOpen.toggle()
                    } label: {
                        Text(itemColor.toHex() ?? "")
                            .font(AppFont.footnote.font)
                            .foregroundStyle(ColorTheme.ColorPalette.blue.color)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $isColorPickerOpen) {
            withAnimation {
                itemColor = newColor
            }
        } content: {
            ColorPicker(color: $newColor, initialColor: itemColor)
        }
    }
}

#Preview {
    ColorCell(itemColor: .constant(.red), newColor: .red, hasColor: .constant(true))
}
