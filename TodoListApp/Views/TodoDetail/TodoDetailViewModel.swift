//
//  TodoDetailViewModel.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 01.07.2024.
//

import Foundation

class TodoDetailViewModel: ObservableObject {
    
    //MARK: Public properties
    let isNew: Bool
    
    let id: String
    let createdAt: Date
    let isCompleted: Bool
    
    @Published var text: String
    @Published var deadline: Date?
    @Published var priority: Priority
    
    var isSaveDisabled: Bool {
        text.isEmpty
    }
    
    var isDeleteDisabled: Bool {
        !isNew
    }
    
    //MARK: Private properties
    private let collectionManager: CollectionManaging
    
    //MARK: Initializer
    init(todoItem: TodoItem, isNew: Bool, collectionManager: CollectionManaging) {
        self.collectionManager = collectionManager
        self.isNew = isNew
        
        
        self.id = todoItem.id
        self.createdAt = todoItem.createdAt
        self.isCompleted = todoItem.isCompleted
        self.text = todoItem.text
        self.deadline = todoItem.deadline
        self.priority = todoItem.priority
    }
    
    //MARK: Public Methods
    func save() {
        
    }
    
    func delete() {
        
    }
}
