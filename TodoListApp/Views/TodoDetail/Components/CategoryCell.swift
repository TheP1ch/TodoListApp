//
//  CategoryCell.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 06.07.2024.
//

import SwiftUI

struct CategoryCell: View {
    @Binding var itemCategory: String
    var categories: [Category]
    var dictCategories: [String: Category]
    
    var category: Category {
        dictCategories[itemCategory] ?? Category.defaultItem
    }
    
    let addAction: () -> ()
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Категория")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(AppFont.body.font)
                    Text(category.name)
                        .font(AppFont.footnote.font)
                        .foregroundStyle(ColorTheme.ColorPalette.blue.color)
                }
                
                CategoryColorCircle(color: category.color)
            }
            picker
            
            newCategory
        }
    }
    
    private var picker: some View {
        ForEach(categories, id: \.id) {item in
            HStack {
                Text(item.name)
                    Spacer()
                CategoryColorCircle(color: item.color)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                itemCategory = item.id
            }
        }
    }
    
    private var newCategory: some View {
        Button {
            addAction()
        } label: {
            HStack {
                NewItemCell()
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .foregroundStyle(ColorTheme.ColorPalette.white.color, ColorTheme.ColorPalette.blue.color)
                    .frame(width: 20, height: 20)
            }
        }
    }
    
}

#Preview {
    CategoryCell(
        itemCategory: .constant("4"),
        categories: Category.unchangableCategories,
        dictCategories: [
            "1": Category.unchangableCategories[0],
            "2": Category.unchangableCategories[1],
            "3": Category.unchangableCategories[2],
            "4": Category.unchangableCategories[3],
        ]
    ) {}
}
