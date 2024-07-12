//
//  FilterOptions.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 01.07.2024.
//

import Foundation

enum FilterOption: String, CaseIterable {
    case all = "Показать"
    case hideDone = "Скрыть"

    var id: Self { self }
}
