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
        fileCache: FileCache(
            fileManagerCSV: FileManagerCSV(),
            fileManagerJson: FileManagerJson()
        )
    )
    
    var body: some Scene {
        WindowGroup {
            TodoListView(
                viewModel: viewModel
            ).onAppear {
                try? viewModel.load()
            }
        }
    }
}
