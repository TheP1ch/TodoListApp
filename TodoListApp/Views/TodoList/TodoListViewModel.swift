//
//  TodoListViewModel.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 29.06.2024.
//

import Foundation
import Combine

final class TodoListViewModel: ObservableObject {
    
    //MARK: public properties
    @Published var items: [TodoItem] = []
    
    var fileCache: FileManaging
    
    //MARK: private properties
    
    
    init(fileCache: FileCache) {
        self.fileCache = fileCache
        
        items = fileCache.todoItems
    }
    
    
    func add(item: TodoItem?) {
        fileCache.add(todoItem: TodoItem(text: "description\(Int.random(in: 4...500))", priority: .low, deadline: Date(timeIntervalSince1970: 10000), isCompleted: true, createdAt: Date(timeIntervalSince1970: 100), changeAt: Date(timeIntervalSince1970: 500)))
        
        updateItems()
    }
    
    func isDoneToggle(for item: TodoItem){
        let item = TodoItem(
            id: item.id,
            text: item.text,
            priority: item.priority,
            deadline: item.deadline,
            isCompleted: !item.isCompleted,
            createdAt: item.createdAt,
            changeAt: item.changeAt
        )
        fileCache.add(todoItem: item)
        
        updateItems()
    }
    
    private func updateItems() {
        self.items = fileCache.todoItems
    }
}
