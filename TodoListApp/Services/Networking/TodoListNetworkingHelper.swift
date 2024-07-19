//
//  TodoListNetworkingHelper.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 19.07.2024.
//

import Combine
import Foundation

protocol TodoNetworkingHelper: Actor {
    var todoItems: [TodoItem] { get }
    var isItemUpdate: PassthroughSubject<Bool, Never> { get }

    func fetchTodoList() async
    func updateTodoList(_ items: [TodoItem]) async
    func fetchTodoItem(with id: String) async
    func addTodoItem(_ item: TodoItem)
    func updateTodoItem(with id: String, _ item: TodoItem)
    func deleteTodoItem(with id: String)
}

actor TodoListNetworkingHelper: TodoNetworkingHelper {
    private(set) var isItemUpdate = PassthroughSubject<Bool, Never>()

    private(set) var todoItems: [TodoItem] = []

    private var revision: Int32 = 0

    private var isDirty: Bool = false

    private let networkingService = DefaultNetworkingService()

    private let minDelay = 2.0
    private let maxDelay = 2.0 * 60
    private let factor = 1.5
    private let jitter = 0.05
    private let maxAttempts = 5

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
            if !isDirty {
                await handleResponse {
                    return try await self.networkingService.postTodoItem(item, revision: self.revision)
                }
            } else {
                await updateTodoList(self.todoItems)
            }
        }
    }

    func updateTodoItem(with id: String, _ item: TodoItem) {
        self.add(item: item)
        Task {
            if !isDirty {
                await handleResponse {
                    return try await self.networkingService.updateTodoItem(with: id, item, revision: self.revision)
                }
            } else {
                await updateTodoList(self.todoItems)
            }
        }
    }

    func deleteTodoItem(with id: String) {
        self.removeItem(by: id)
        Task {
            if !isDirty {
                await handleResponse {
                    return try await self.networkingService.deleteTodoItem(with: id, revision: self.revision)
                }
            } else {
                await updateTodoList(self.todoItems)
            }
        }
    }
}

extension TodoListNetworkingHelper {
    private func handleResponse<T: TodoResponse>(
        networkCall: @escaping () async throws -> T,
        onSuccess: @escaping (T.ResponseResult) -> Void = {_ in }
    ) async {
        var delay = minDelay

        for i in 0...5 {
            do {
                let response = try await networkCall()
                self.revision = response.revision

                onSuccess(response.result)
                isDirty = false
                break
            } catch {
                delay = calculateDelay(attemp: i, prevDelay: delay)
                if let error = error as? NetworkingError {
                    Logger.log("HandleResponseFunc networking Error: \(error)", level: .error)
                    if case .httpError(statusCode: 400) = error {
                        await updateTodoList(self.todoItems)
                        return
                    }
                } else {
                    Logger.log("Error handleResponse \(error)", level: .error)
                }

                if i < 5 {
                    do {
                        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    } catch {
                        Logger.log("Task sleep error", level: .error)
                    }
                    continue
                } else {
                    isDirty = true
                }
            }
        }
    }
}

// MARK: Calculation Delay
extension TodoListNetworkingHelper {
    func calculateDelay(attemp: Int, prevDelay: Double) -> Double {
        let delay = min(prevDelay * pow(factor, Double(attemp)), maxDelay)

        return delay * (1 + Double.random(in: -jitter...jitter))
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

        isItemUpdate.send(true)

        Logger.log("NetworkHelper List updated", level: .debug)
    }
}