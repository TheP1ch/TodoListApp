//
//  ColorPickerNavWrapper.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 06.07.2024.
//

import SwiftUI

struct ColorPickerNavWrapper: View {
    @Binding var itemColor: Color
    
    @State var newColor: Color

    @Environment(\.dismiss)
    private var dismiss
    
    var body: some View {
        NavigationStack {
            ColorPicker(itemColor: $itemColor, newColor: $newColor)
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 24))
                .navigationTitle("Выберите цвет")
                .navigationBarTitleDisplayMode(.inline)
                .scrollContentBackground(.hidden)
                .background(ColorTheme.Back.backPrimary.color)
                .toolbar {
                    toolbarContent
                }
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                withAnimation {
                    itemColor = newColor
                }
                dismiss()
            } label: {
                Text("Добавить")
                    .foregroundStyle( ColorTheme.ColorPalette.blue.color
                    )
            }
        }
        
        ToolbarItem(placement: .topBarLeading) {
            Button {
                dismiss()
            } label: {
                Text("Отменить")
                    .foregroundStyle( ColorTheme.ColorPalette.blue.color
                    )
            }
        }
    }
}

#Preview {
    ColorPickerNavWrapper(itemColor: .constant(.red), newColor: .green)
}
