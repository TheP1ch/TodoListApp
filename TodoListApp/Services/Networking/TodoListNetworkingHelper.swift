//
//  TodoListNetworkingHelper.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 19.07.2024.
//

import Foundation

protocol TodoNetworkingHelper: Actor {
    var todoItems: [TodoItem] { get }

    func fetchTodoList() async
    func updateTodoList(_ items: [TodoItem]) async
    func fetchTodoItem(with id: String) async
    func addTodoItem(_ item: TodoItem)
    func updateTodoItem(with id: String, _ item: TodoItem)
    func deleteTodoItem(with id: String)
}

actor TodoListNetworkingHelper: TodoNetworkingHelper {
    private(set) var todoItems: [TodoItem] = []

    private var revision: Int32 = 0

    private var isDirty: Bool = false

    private let networkingService = DefaultNetworkingService()

    init() {
        Logger.log("NetworkingHelper init", level: .debug)
    }

    func fetchTodoList() async {
        await handleResponse {
            try await self.networkingService.fetchTodoList()
        } onSuccess: { result in
            self.update(items: result)
        }
    }

    func updateTodoList(_ items: [TodoItem]) async {
        await handleResponse {
            return try await self.networkingService.patchTodoList(items, revision: self.revision)
        } onSuccess: { result in
            self.update(items: result)
        }
    }

    func fetchTodoItem(with id: String) async {
        await handleResponse {
            try await self.networkingService.fetchTodoItem(with: id)
        }
    }

    func addTodoItem(_ item: TodoItem) {
        self.add(item: item)
        Task {
            await handleResponse {
                return try await self.networkingService.postTodoItem(item, revision: self.revision)
            }
        }
    }

    func updateTodoItem(with id: String, _ item: TodoItem) {
        self.add(item: item)
        Task {
            await handleResponse {
                return try await self.networkingService.updateTodoItem(with: id, item, revision: self.revision)
            }
        }
    }

    func deleteTodoItem(with id: String) {
        self.removeItem(by: id)
        Task {
            await handleResponse {
                return try await self.networkingService.deleteTodoItem(with: id, revision: self.revision)
            }
        }
    }
}

extension TodoListNetworkingHelper {
    private func handleResponse<T: TodoResponse>(
        networkCall: @escaping () async throws -> T,
        onSuccess: @escaping (T.ResponseResult) -> Void = {_ in }
    ) async {
        do {
            let response = try await networkCall()
            self.revision = response.revision

            onSuccess(response.result)
        } catch let error as NetworkingError {
            Logger.log("HandleResponseFunc networking Error: \(error)", level: .error)

        } catch {
            Logger.log("Error handleResponse \(error)", level: .error)

        }
    }
}

// MARK: Update actor todoItems
extension TodoListNetworkingHelper {
    private func add(item: TodoItem) {
        for i in 0..<todoItems.count {
            if todoItems[i].id == item.id {
                todoItems[i] = item
                return
            }
        }
        todoItems.append(item)

        Logger.log("NetworkHelper Item add", level: .debug)
    }

    private func removeItem(by id: String) {
        for i in 0..<todoItems.count {
            if todoItems[i].id == id {
                todoItems.remove(at: i)
                return
            }
        }

        Logger.log("NetworkHelper Item removed", level: .debug)
    }

    private func update(items: [TodoItem]) {
        todoItems = items

        Logger.log("NetworkHelper List updated", level: .debug)
    }
}
