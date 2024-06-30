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
    
    var fileCache: FileCache
    
    //MARK: private properties
    
    
    init(fileCache: FileCache) {
        self.fileCache = fileCache
        
        items = fileCache.todoItems
    }
    
    
    func add(item: TodoItem?) {
        fileCache.add(todoItem: TodoItem(text: "description\(Int.random(in: 4...500))", priority: .low, deadline: Date(timeIntervalSince1970: 10000), isCompleted: true, createdAt: Date(timeIntervalSince1970: 100), changeAt: Date(timeIntervalSince1970: 500)))
        
        self.items = fileCache.todoItems
    }
    
    func isDoneToggle(for item: TodoItem){
        
    }
}
