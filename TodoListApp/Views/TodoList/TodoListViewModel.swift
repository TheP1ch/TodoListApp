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
    
    @Published var filterOption: FilterOption = .hideDone {
        didSet {
            Logger.log("Items will be filtered by option: \(filterOption)", level: .debug)
        }
    }
    
    @Published var sortOption: SortOption = .createdAt {
        didSet {
            Logger.log("Items will be sorted by option: \(sortOption)", level: .debug)
        }
    }
    
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
        Logger.log("TodoItem with id: '\(item.id)' added", level: .debug)
        updateItems()
    }
    
    func remove(by id: String) {
        fileCache.removeItem(by: id)
        
        Logger.log("TodoItem with id: '\(id)' removed", level: .debug)
        
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
            hexColor: item.hexColor,
            category: item.category
        )
        
        fileCache.add(todoItem: item)
        
        Logger.log(
            "isCompleted change to \(newValue.description) for TodoItem with text:'\(item.text)'",
            level: .debug
        )
        
        updateItems()
    }
    
    func load() {
        do {
            try fileCache.load(fileName: fileName, format: format)
        } catch {
            Logger.log("Load from file error: \(error.localizedDescription)", level: .error)
        }

        items = fileCache.todoItems
    }
    
    //MARK: private methods
    
    private func updateItems() {
        self.items = fileCache.todoItems
        
        do {
            try self.fileCache.save(fileName: self.fileName, format: self.format)
            
            Logger.log("Items saved", level: .debug)
        } catch {
            Logger.log("Save to file error: \(error.localizedDescription)", level: .error)
        }
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
