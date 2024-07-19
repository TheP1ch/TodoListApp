//
//  TodoListResponse.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 19.07.2024.
//

import Foundation

struct TodoListResponse: TodoResponse {
    var status: String
    var result: [TodoItem]
    var revision: Int32

    enum CodingKeys: String, CodingKey {
        case status
        case result = "list"
        case revision
    }
}
