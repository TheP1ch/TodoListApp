//
//  SortOptions.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 01.07.2024.
//

import Foundation

enum SortOption: String, CaseIterable {
    case priority = "Важности"
    case createdAt = "Добавлению"

    var id: Self { self }
}
