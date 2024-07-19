//
//  TodoListAppApp.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 17.06.2024.
//

import SwiftUI

@main
struct TodoListApp: App {
    @StateObject
    var viewModel: TodoListViewModel = TodoListViewModel()

    private let logger = Logger()

    init() {
        logger.initLogger()
    }

    var body: some Scene {
        WindowGroup {
            TodoListView(
                viewModel: viewModel
            ).onAppear {
                viewModel.load()
            }
        }
    }
}
