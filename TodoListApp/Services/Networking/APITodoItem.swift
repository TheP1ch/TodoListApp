//
//  API.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 19.07.2024.
//

import Foundation
import URL

enum API {
    private static let baseUrl = #URL("https://hive.mrdekk.ru/todo")
    private static let token = "Bearer Galadriel"
    private static let basePathComponent = "list"

    case getTodoList
    case patchTodoList(revision: Int32)
    case getTodoItem(id: String)
    case postTodoItem(revision: Int32)
    case updateTodoItem(id: String, revision: Int32)
    case deleteTodoItem(id: String, revision: Int32)

    private var url: URL {
        let url = API.baseUrl.appending(path: API.basePathComponent)

        switch self {
        case .getTodoItem(let id), .updateTodoItem(let id, _), .deleteTodoItem(let id, _):
            return url.appending(path: "\(id)")
        case .getTodoList, .patchTodoList, .postTodoItem:
            return url
        }
    }

    private var method: String {
        switch self {
        case .getTodoList, .getTodoItem:
            "GET"
        case .patchTodoList:
            "PATCH"
        case .postTodoItem:
            "POST"
        case .updateTodoItem:
            "PUT"
        case .deleteTodoItem:
            "DELETE"
        }
    }

    private var headers: [String: String] {
        var headers = [String: String]()
        headers["Authorization"] = API.token

        switch self {
        case .patchTodoList(let revision),
                .postTodoItem(let revision),
                .updateTodoItem(_, let revision),
                .deleteTodoItem(_, let revision):
            headers["X-Last-Known-Revision"] = "\(revision)"
        case .getTodoList, .getTodoItem:
            break
        }

        return headers
    }

    func request<T: Encodable>(with body: T = nil) throws -> URLRequest {
        var request = URLRequest(url: url)

        assert(Thread.current != Thread.main)

        if let body = body {
            do {
                if let itemBody = body as? [String: Any] {
                    request.httpBody = try JSON
                } else if let listBody = body as? [[String: Any]] {
                    request.httpBody = try JSONSerialization.data(withJSONObject: listBody)
                } else {
                    throw NetworkingError.invalidBody
                }
            } catch {
                Logger.log("API.request: \(error.localizedDescription)", level: .error)
                throw error
            }
        }

        return request
    }
}
