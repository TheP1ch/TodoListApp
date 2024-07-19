//
//  NetworkingError.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 19.07.2024.
//

import Foundation

enum NetworkingError: Error {
    case invalidResponse
    case httpError(statusCode: Int)
    case serverError
    case unknown
}
