//
//  DefaultNetworkingService.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 19.07.2024.
//

import Foundation

final class DefaultNetworkingService {
    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    // MARK: Get requests
    func fetchTodoList() async throws -> TodoListResponse {
        Logger.log("GET todoList", level: .debug)
        let request = try APITodoItem.getTodoList.request()
        return try await performRequest(for: request)
    }

    func fetchTodoItem(with id: String) async throws -> TodoItemResponse {
        Logger.log("GET todoItem", level: .debug)
        let request = try APITodoItem.getTodoItem(id: id).request()
        return try await performRequest(for: request)
    }

    // MARK: Patch requests
    func patchTodoList(_ data: [TodoItem], revision: Int32) async throws -> TodoListResponse {
        Logger.log("PATCH todoList", level: .debug)

        let body = TodoListDTO(list: data)

        let request = try APITodoItem.patchTodoList(revision: revision).request(with: body)
        return try await performRequest(for: request)
    }

    // MARK: Post requests
    func postTodoItem(_ data: TodoItem, revision: Int32) async throws -> TodoItemResponse {
        Logger.log("POST todoItem", level: .debug)

        let body = TodoItemDTO(element: data)

        let request = try APITodoItem.postTodoItem(revision: revision).request(with: body)
        return try await performRequest(for: request)
    }

    // MARK: Put requests
    func updateTodoItem(with id: String, _ data: TodoItem, revision: Int32) async throws -> TodoItemResponse {
        Logger.log("PUT todoItem", level: .debug)

        let body = TodoItemDTO(element: data)

        let request = try APITodoItem.updateTodoItem(id: id, revision: revision).request(with: body)
        return try await performRequest(for: request)
    }

    // MARK: Delete requests
    func deleteTodoItem(with id: String, revision: Int32) async throws -> TodoItemResponse {
        Logger.log("DELETE todoItem", level: .debug)

        let request = try APITodoItem.deleteTodoItem(id: id, revision: revision).request()
        return try await performRequest(for: request)
    }

    // MARK: Perform request method
    private func performRequest<T: TodoResponse>(for request: URLRequest) async throws -> T {
        let (data, response) = try await session.dataTask(for: request)
        try checkResponse(response)

        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .secondsSince1970

        let object = try jsonDecoder.decode(T.self, from: data)

        return object
    }

    private func checkResponse(_ response: URLResponse) throws {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkingError.invalidResponse
        }

        switch response.statusCode {
        case 200...299:
            return
        case 400...499:
            throw NetworkingError.httpError(statusCode: response.statusCode)
        case 500...599:
            throw NetworkingError.serverError
        default:
            throw NetworkingError.unknown
        }
    }
}
