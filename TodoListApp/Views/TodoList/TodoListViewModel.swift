//
//  TodoListViewModel.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 29.06.2024.
//

import Foundation

protocol CollectionManaging {
    func add(item: TodoItem?)
    func remove(item: TodoItem)
}

final class TodoListViewModel: ObservableObject, CollectionManaging {
    
    //MARK: public properties
    var sortedItems: [TodoItem] {
        let filteredItems = self.filter(with: filterOption)
        return sort(filteredItems, with: sortOption)
    }
    
    @Published var filterOption: FilterOption = .hideDone
    
    @Published var sortOption: SortOption = .createdAt
    
    var isDoneCount: Int {
        fileCache.todoItems.reduce(0) { value, item in
            value + (item.isCompleted ? 1 : 0)
        }
    }
    
    //MARK: private properties
    
    @Published private var items: [TodoItem] = []
    
    private var fileCache: FileManaging
    
    //MARK: Initializer
    
    init(fileCache: FileCache) {
        self.fileCache = fileCache
        
        items = fileCache.todoItems
    }
    
    //MARK: public methods
    
    func add(item: TodoItem?) {
        fileCache.add(todoItem: TodoItem(text: "description\(Int.random(in: 4...500))", priority: .low, deadline: Date(timeIntervalSince1970: 10000), isCompleted: false, createdAt: Date.now, changeAt: Date(timeIntervalSince1970: 500)))
        
        updateItems()
    }
    
    func remove(item: TodoItem) {
        fileCache.removeItem(by: item.id)
        
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
    
    //MARK: private methods
    
    private func updateItems() {
        self.items = fileCache.todoItems
        
    }
    
    
    private func filter(with filterOption: FilterOption) -> [TodoItem] {
        switch filterOption {
        case .all:
            return self.items
        case .hideDone:
            return self.items.filter { $0.isCompleted == false }
        }
    }
    
    private func sort(_ items: [TodoItem], with sortOption: SortOption) -> [TodoItem] {
        switch sortOption {
        case .createdAt:
            return items.sorted {
                $0.createdAt > $1.createdAt
            }
        case .priority:
            return items.sorted {
                $0.priority > $1.priority
            }
        }
    }
}
