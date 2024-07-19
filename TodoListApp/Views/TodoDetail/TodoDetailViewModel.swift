//
//  TodoDetailViewModel.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 01.07.2024.
//

import SwiftUI

final class TodoDetailViewModel: ObservableObject {

    // MARK: Public properties

    let isNew: Bool

    @Published var text: String
    @Published var deadline: Date
    @Published var priority: Priority
    @Published var hasDeadline: Bool
    @Published var color: Color
    @Published var hasColor: Bool
    @Published var category: String

    var isSaveDisabled: Bool {
        text.isEmpty
    }

    var isDeleteDisabled: Bool

    // MARK: Private properties
    private let collectionManager: CollectionManaging

    let id: String
    let createdAt: Date
    let isCompleted: Bool

    // MARK: Initializer
    init(todoItem: TodoItem, isNew: Bool, collectionManager: CollectionManaging) {
        self.collectionManager = collectionManager

        self.id = todoItem.id
        self.createdAt = todoItem.createdAt
        self.isCompleted = todoItem.isCompleted
        self.text = todoItem.text
        self.deadline = if let deadline = todoItem.deadline { deadline } else {Date.tommorow}
        self.priority = todoItem.priority
        self.hasDeadline = todoItem.deadline == nil ? false : true

        self.isDeleteDisabled = todoItem.text.isEmpty ? true : false

        self.hasColor = todoItem.hexColor == nil ? false : true
        if let hexColor = todoItem.hexColor, let color = Color(hex: hexColor) {
            self.color = color
        } else {
            self.color = .red
        }

        self.category = todoItem.category ?? Category.defaultItem.id

        self.isNew = isNew
    }

    // MARK: Public Methods
    func save() {
        let deadline = hasDeadline ? deadline : nil
        let hexColor = hasColor ? color.toHex() : nil

        let item = TodoItem(
            id: self.id,
            text: self.text,
            priority: self.priority,
            deadline: deadline,
            isCompleted: self.isCompleted,
            createdAt: self.createdAt,
            changeAt: Date.now,
            hexColor: hexColor,
            category: category
        )

        if isNew {
            collectionManager.add(item: item)
        } else {
            collectionManager.update(item: item)
        }
    }

    func delete() {
        collectionManager.remove(by: self.id)
    }
}
