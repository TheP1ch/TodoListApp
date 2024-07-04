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
    
    @Binding var hasColor: Bool

    let onTap: () -> Void
    
    //MARK: Body
    var body: some View {
        Toggle(isOn: $hasColor) {
            VStack(alignment: .leading) {
                Text("Цвет")
                    .font(AppFont.body.font)
                    .foregroundStyle(ColorTheme.Label.labelPrimary.color)
                
                
                if hasColor {
                    Button {
                        onTap()
                    } label: {
                        Text(itemColor.toHex() ?? "")
                            .font(AppFont.footnote.font)
                            .foregroundStyle(ColorTheme.ColorPalette.blue.color)
                    }
                }
            }
        }
    }
}

#Preview {
    ColorCell(itemColor: .constant(.red), hasColor: .constant(true)) {}
}
