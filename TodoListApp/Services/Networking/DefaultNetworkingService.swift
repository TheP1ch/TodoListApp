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
    func fetchTodoList() async throws -> Any {

    }
}
