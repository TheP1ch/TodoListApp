//
//  TodoListStorageHelper.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 26.07.2024.
//

import Foundation
import SwiftData

protocol TodoStorageHelper: Actor {
    var items: [TodoItem] {get}

    init(container: ModelContainer)

    @discardableResult
    func fetch() -> [TodoItem]
    func insert(_ todoItem: TodoItem)
    func delete(_ todoItem: TodoItem)
    func update(_ todoItem: TodoItem)
    func updateAll(_ todoItems: [TodoItem])
    func filteredFetch(filterOption: FilterOption, sortOption: SortOption) -> [TodoItem]
    func isDoneCount() -> Int
}

final actor TodoListStorageHelper: ModelActor, TodoStorageHelper {

    private(set) var items: [TodoItem] = []

    let modelContainer: ModelContainer
    let modelExecutor: any ModelExecutor
    private var modelContext: ModelContext { modelExecutor.modelContext }

    init(container: ModelContainer) {
        modelContainer = container
        let context = ModelContext(modelContainer)
        context.autosaveEnabled = false

        modelExecutor = DefaultSerialModelExecutor(modelContext: context)
    }

    @discardableResult
    func fetch() -> [TodoItem] {
        let fetchDescriptor = FetchDescriptor<TodoItemModel>()

        let list: [TodoItem]
        do {
            list = try modelContext.fetch(fetchDescriptor).map { TodoItem($0) }
        } catch {
            list = []
        }

        items = list

        Logger.log("Fetch all data from Storage", level: .debug)

        return list
    }

    func insert(_ todoItem: TodoItem) {
        items.append(todoItem)
        let model = TodoItemModel(todoItem: todoItem)

        modelContext.insert(model)
        try? modelContext.save()

        Logger.log("Add item id: '\(todoItem.id)', text: \(todoItem.text) in Storage", level: .debug)
    }

    func delete(_ todoItem: TodoItem) {
        let modelId = todoItem.id

        let deletePredicate = #Predicate<TodoItemModel> { item in
            item.id == modelId
        }

        do {
            try modelContext.delete(model: TodoItemModel.self, where: deletePredicate)
            try modelContext.save()
            Logger.log("Delete item id: '\(todoItem.id)', text: \(todoItem.text) in Storage", level: .debug)
        } catch {
            Logger.log("can't delete item id: '\(todoItem.id)', text: \(todoItem.text) in Storage", level: .debug)
        }
    }

    func update(_ todoItem: TodoItem) {
        for i in 0..<items.count {
            if items[i].id == todoItem.id {
                items[i] = todoItem
            }
        }

        let model = TodoItemModel(todoItem: todoItem)

        modelContext.insert(model)
        try? modelContext.save()

        Logger.log("Update item id: '\(todoItem.id)', text: \(todoItem.text) in Storage", level: .debug)
    }

    func updateAll(_ todoItems: [TodoItem]) {
        delete(fetch())

        for item in todoItems {
            insert(item)
        }

        Logger.log("Update all data in Storage", level: .debug)
    }

    func filteredFetch(filterOption: FilterOption, sortOption: SortOption) -> [TodoItem] {
        let isAll: Bool
        if filterOption == .all {
            isAll = true
        } else {
            isAll = false
        }

        let predicate = #Predicate<TodoItemModel> { item in
            if isAll {
                return true
            } else {
                return item.isCompleted == isAll
            }
        }

        let sortDescriptor: SortDescriptor<TodoItemModel>
        switch sortOption {
        case .createdAt:
            sortDescriptor = .init(\.createdAt)
        case .priority:
            sortDescriptor = .init(\.priorityRawValue)
        }

        let fetchDescriptor = FetchDescriptor<TodoItemModel>(predicate: predicate, sortBy: [sortDescriptor])

        let list: [TodoItem]
        do {
            list = try modelContext.fetch(fetchDescriptor).map { TodoItem($0) }
        } catch {
            list = []
        }

        Logger.log("Fetch filtered data from storage", level: .debug)

        return list
    }

    func isDoneCount() -> Int {
        let predicate = #Predicate<TodoItemModel> { item in
            item.isCompleted == true
        }

        let count: Int
        do {
            count = try modelContext.fetchCount(FetchDescriptor<TodoItemModel>(predicate: predicate))
        } catch {
            count = 0
        }

        return count
    }

    private func delete(_ todoItems: [TodoItem]) {
        for item in todoItems {
            delete(item)
        }

        Logger.log("Delete all data in Storage", level: .debug)
    }
}
