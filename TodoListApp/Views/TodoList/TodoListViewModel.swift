//
//  TodoListViewModel.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 29.06.2024.
//

import Foundation

protocol CollectionManaging: AnyObject {
    func add(item: TodoItem)
    func remove(by id: String)
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
    
    @Published private(set) var items: [TodoItem] = []
    
    private var fileCache: FileManaging
    
    private let fileName: String
    
    private let format: FileFormat
    
    //MARK: Initializer
    
    init(fileName: String, format: FileFormat, fileCache: FileCache) {
        self.fileCache = fileCache
        
        self.fileName = fileName
        self.format = format
    }
    
    //MARK: public methods
    
    func add(item: TodoItem) {
        fileCache.add(todoItem: item)
        
        updateItems()
    }
    
    func remove(by id: String) {
        fileCache.removeItem(by: id)
        
        updateItems()
    }
    
    func isCompletedChange(for item: TodoItem, newValue: Bool){
        let item = TodoItem(
            id: item.id,
            text: item.text,
            priority: item.priority,
            deadline: item.deadline,
            isCompleted: newValue,
            createdAt: item.createdAt,
            changeAt: item.changeAt,
            hexColor: item.hexColor
        )
        fileCache.add(todoItem: item)
        
        updateItems()
    }
    
    func load() throws {
        try self.fileCache.load(fileName: self.fileName, format: self.format)
        items = fileCache.todoItems
    }
    
    //MARK: private methods
    
    private func updateItems() {
        self.items = fileCache.todoItems
        
        try? self.fileCache.save(fileName: self.fileName, format: self.format)
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
