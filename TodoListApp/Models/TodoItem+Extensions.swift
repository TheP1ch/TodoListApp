//
//  TodoItem+Extensions.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 26.07.2024.
//

import Foundation

extension TodoItem {
    init(_ item: TodoItemModel) {
        self.init(
            id: item.id,
            text: item.text,
            priority: item.priority,
            deadline: item.deadline,
            isCompleted: item.isCompleted,
            createdAt: item.createdAt,
            changeAt: item.changeAt,
            hexColor: item.hexColor,
            category: item.category,
            lastUpdatedBy: item.lastUpdatedBy
        )
    }
}
