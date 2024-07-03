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

    //MARK: Body    
    var body: some View {
        TextField("Что надо сделать?", text: $text, axis: .vertical)
        .frame(minHeight: 120, alignment: .topLeading)
        .foregroundStyle(
            ColorTheme.Label.labelPrimary.color
        )
        .background(ColorTheme.Back.backSecondary.color)
    }
    
}

#Preview {
    TextFieldCell(text: .constant("ee"))
}
