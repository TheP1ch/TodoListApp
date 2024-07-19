//
//  TodoListViewModel.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 29.06.2024.
//

import Foundation

protocol CollectionManaging: AnyObject {
    func add(item: TodoItem)
    func remove(by id: String)
}

final class TodoListViewModel: ObservableObject, CollectionManaging {
    // MARK: public properties
    var sortedItems: [TodoItem] {
        let filteredItems = self.filter(with: filterOption)
        return sort(filteredItems, with: sortOption)
    }

    @Published var filterOption: FilterOption = .hideDone {
        didSet {
            Logger.log("Items will be filtered by option: \(filterOption)", level: .debug)
        }
    }

    @Published var sortOption: SortOption = .createdAt {
        didSet {
            Logger.log("Items will be sorted by option: \(sortOption)", level: .debug)
        }
    }

    var isDoneCount: Int {
        items.reduce(0) { value, item in
            value + (item.isCompleted ? 1 : 0)
        }
    }

    // MARK: private properties

    @Published private(set) var items: [TodoItem] = []

    private let networkHelper: TodoNetworkingHelper = TodoListNetworkingHelper()

    private let fileCache: FileManaging = FileCache()

    private let fileName: String = FileCache.fileName

    private let format: FileFormat = FileCache.fileExtension

    // MARK: private methods
    private func filter(with filterOption: FilterOption) -> [TodoItem] {
        switch filterOption {
        case .all:
            return self.items
        case .hideDone:
            return self.items.filter { $0.isCompleted == false }
        }
    }

    private func sort(_ items: [TodoItem], with sortOption: SortOption) -> [TodoItem] {
        switch sortOption {
        case .createdAt:
            return items.sorted {
                $0.createdAt > $1.createdAt
            }
        case .priority:
            return items.sorted {
                $0.priority > $1.priority
            }
        }
    }
}

// MARK: Networking
extension TodoListViewModel {
    func load() {
        Task {
            await networkHelper.fetchTodoList()

            Logger.log("Task loaded", level: .debug)

            updateItems()
        }
    }

    func isCompletedChange(for item: TodoItem, newValue: Bool) {
        let item = TodoItem(
            id: item.id,
            text: item.text,
            priority: item.priority,
            deadline: item.deadline,
            isCompleted: newValue,
            createdAt: item.createdAt,
            changeAt: item.changeAt,
            hexColor: item.hexColor,
            category: item.category
        )

        Task {
            await networkHelper.updateTodoItem(with: item.id, item)

            Logger.log(
                "isCompleted change to \(newValue.description) for TodoItem with text:'\(item.text)'",
                level: .debug
            )

            updateItems()
        }
    }

    func add(item: TodoItem) {
        Task {
            await networkHelper.addTodoItem(item)
            Logger.log("TodoItem with id: '\(item.id)' added", level: .debug)

            updateItems()
        }

    }

    func remove(by id: String) {
        Task {
            await networkHelper.deleteTodoItem(with: id)
            Logger.log("TodoItem with id: '\(id)' removed", level: .debug)

            updateItems()
        }
    }

    private func updateItems() {
        Task {
            let helperItems = await networkHelper.todoItems

            await MainActor.run {
                self.items = helperItems
                Logger.log("ViewModel List Updated", level: .debug)
            }
        }
    }
}
