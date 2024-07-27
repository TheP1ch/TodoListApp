//
//  TodoItemModel+Extensions.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 26.07.2024.
//

import Foundation

extension TodoItemModel {
    convenience init(todoItem: TodoItem) {
        self.init(
            id: todoItem.id,
            text: todoItem.text,
            createdAt: todoItem.createdAt,
            isCompleted: todoItem.isCompleted,
            priorityRawValue: todoItem.priority.rawValue,
            deadline: todoItem.deadline,
            changeAt: todoItem.changeAt,
            hexColor: todoItem.hexColor,
            category: todoItem.category,
            lastUpdatedBy: todoItem.lastUpdatedBy
        )
    }
}
