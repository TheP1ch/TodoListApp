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
    var viewModel: TodoListViewModel = TodoListViewModel(
        fileName: FileCache.fileName,
        format: FileCache.fileExtension,
        fileCache: FileCache()
    )

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

                let task = Task {
                    print("start data")
                    let task = try await URLSession.shared.dataTask(for: URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/todos/1")!))
                    print("end data")
                    print(task.0)
                }

                task.cancel()
                print("cancel")
            }
        }
    }
}
