//
//  TodoItemResponse.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 19.07.2024.
//

import Foundation

struct TodoItemResponse: TodoResponse {
    var status: String
    var result: TodoItem
    var revision: Int32

    enum CodingKeys: String, CodingKey {
        case status
        case result = "element"
        case revision
    }
}
