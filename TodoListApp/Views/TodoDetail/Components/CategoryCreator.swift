//
//  CategoryCreator.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 06.07.2024.
//

import SwiftUI

struct CategoryCreator: View {
    @State var categoryColor: Color = .clear

    @State var text: String = ""

    var onSave: (Category) -> Void

    @Environment(\.dismiss)
    private var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    TextField("Введите название категории", text: $text, axis: .vertical)
                        .frame(minHeight: 100, maxHeight: 250)
                        .padding(.horizontal)
                    .foregroundStyle(
                        ColorTheme.Label.labelPrimary.color
                    )
                    .background(ColorTheme.Back.backSecondary.color)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding()
                }

                ColorPicker(itemColor: $categoryColor, newColor: $categoryColor)
                    .toolbar {
                        toolbarContent
                    }
            }
            .background(ColorTheme.Back.backPrimary.color)
            .navigationTitle("Категории")
            .navigationBarTitleDisplayMode(.inline)
        }

    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                withAnimation {
                    onSave(Category(hexColor: categoryColor.toHex(), name: text))
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
    CategoryCreator(categoryColor: .gray) {_ in}
}
