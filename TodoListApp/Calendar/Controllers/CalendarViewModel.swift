//
//  CalendarViewModel.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 05.07.2024.
//

import Foundation

final class CalendarViewModel {
     var todoItems: [TodoItem] = []
    
    func update(items: [TodoItem]) {
        self.todoItems = items
    }
}
