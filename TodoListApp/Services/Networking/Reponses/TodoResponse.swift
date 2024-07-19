//
//  TodoResponse.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 19.07.2024.
//

import Foundation

protocol TodoResponse: Codable {
    associatedtype ResponseResult

    var status: String { get }
    var result: ResponseResult { get }
    var revision: Int32 { get }
}
