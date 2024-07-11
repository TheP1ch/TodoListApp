//
//  Category.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 06.07.2024.
//

import SwiftUI

struct Category: Identifiable, Hashable, Codable {
    static var new: Category {
        Category(hexColor: Color.green.toHex(), name: "Test")
    }

    static var unchangableCategories: [Category] {
        [
            Category(id: "1", hexColor: ColorTheme.ColorPalette.red.color.toHex(), name: "Работа"),
            Category(id: "2", hexColor: ColorTheme.ColorPalette.blue.color.toHex(), name: "Учеба"),
            Category(id: "3", hexColor: ColorTheme.ColorPalette.green.color.toHex(), name: "Хобби"),
            self.defaultItem
        ]
    }

    static var defaultItem: Category {
        Category(id: "4", hexColor: Color.clear.toHex(), name: "Другое")
    }

    let id: String
    let hexColor: String
    let name: String

    var color: Color {
        Color(hex: hexColor) ?? Color.clear
    }

    init(id: String = UUID().uuidString, hexColor: String, name: String) {
        self.id = id
        self.hexColor = hexColor
        self.name = name
    }
}
