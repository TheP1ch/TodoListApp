//
//  TodoItemModel.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 26.07.2024.
//

import Foundation
import SwiftData

@Model
final class TodoItemModel {
    @Attribute(.unique)
    var id: String

    @Attribute(originalName: "created_at")
    var createdAt: Date

    var priority: Priority {
        if let priority = Priority(rawValue: priorityRawValue) {
            return priority
        } else {
            Logger.log("SwiftDataModel initialization error: 'unexpected priority rawValue'", level: .error)
            return .basic

        }
    }
    var priorityRawValue: String

    @Attribute(originalName: "change_at")
    var changeAt: Date

    var isCompleted: Bool
    var text: String
    var deadline: Date?
    var hexColor: String?
    var category: String?
    var lastUpdatedBy: String?

    init(
        id: String,
        text: String,
        createdAt: Date,
        isCompleted: Bool,
        priorityRawValue: String,
        deadline: Date?,
        changeAt: Date,
        hexColor: String?,
        category: String?,
        lastUpdatedBy: String?
    ) {
        self.id = id
        self.text = text
        self.createdAt = createdAt
        self.isCompleted = isCompleted
        self.priorityRawValue = priorityRawValue
        self.deadline = deadline
        self.changeAt = changeAt
        self.hexColor = hexColor
        self.category = category
        self.lastUpdatedBy = lastUpdatedBy
    }
}
