//
//  TodoListAppApp.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 17.06.2024.
//

import SwiftUI

@main
struct TodoListApp: App {
    
    
    var body: some Scene {
        WindowGroup {
            TodoListView(viewModel: TodoListViewModel(fileCache: FileCache(fileManagerCSV: FileManagerCSV(), fileManagerJson: FileManagerJson())))
        }
    }
}
