//
//  TextFieldCell.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 01.07.2024.
//

import SwiftUI

struct TextFieldCell: View {
    //MARK: Public Properties
    @Binding var text: String
    
    @Binding var hasColor: Bool
    
    @Binding var color: Color

    //MARK: Body    
    var body: some View {
        HStack {
            TextField("Что надо сделать?", text: $text, axis: .vertical)
                .frame(maxHeight: .infinity, alignment: .topLeading)
            .foregroundStyle(
                ColorTheme.Label.labelPrimary.color
            )
            .background(ColorTheme.Back.backSecondary.color)
            .padding(.top, 16)
            
            if hasColor {
                colorLine
            }
        }
    }
    
    private var colorLine: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(color)
            .frame(width: 4)
    }
    
}

#Preview {
    TextFieldCell(text: .constant("ee"), hasColor: .constant(true),color: .constant(.green))
}
