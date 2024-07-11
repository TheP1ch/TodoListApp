//
//  AddNewItemButton.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 30.06.2024.
//

import SwiftUI

struct AddNewItemButton: View {

    var action: (() -> Void)?

    var body: some View {
        Button {
            action?()
        } label: {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 44, height: 44, alignment: .center)
                .foregroundStyle(
                    ColorTheme.ColorPalette.white.color,
                    ColorTheme.ColorPalette.blue.color
                )
        }.shadow(
            color: ColorTheme.ButtonShadow.addNew.color,
            radius: 20,
            x: 0,
            y: 8
        )
    }
}

#Preview {
    AddNewItemButton()
}
