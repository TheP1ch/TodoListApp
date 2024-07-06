//
//  CalendarViewModel.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 05.07.2024.
//

import Foundation

final class CalendarViewModel {
    private(set) var todoItems: [TodoItem] = []
    
    private(set) var categoryViewModel: CategoryViewModel
    
    init(categoryViewModel: CategoryViewModel) {
        self.categoryViewModel = categoryViewModel
    }
    
    var items: [(Date?, [TodoItem])] {
        return sortByDeadline(items: todoItems)
    }
    
    var dates: [Date?] {
        items.map {
            $0.0
        }
    }
    
    func update(items: [TodoItem]) {
        self.todoItems = items
    }
    
    private func sortByDeadline(items: [TodoItem]) -> [(Date?, [TodoItem])] {
        var dictionary: [Date : (Date, [TodoItem])] = [:]
        var withoutDeadline: (Date?, [TodoItem]) = (nil, [])
        
        
        items.forEach { item in
            guard let deadline = item.deadline else {
                withoutDeadline.1.append(item)
                return
            }
            
            let startOfDay = Calendar.current.startOfDay(for: deadline)
            
            if dictionary[startOfDay] == nil {
                dictionary[startOfDay] = (startOfDay, [])
            }
            
            dictionary[startOfDay]?.1.append(item)
        }
        
        var sortedDeadlineArr: [(Date?, [TodoItem])] = dictionary.values.sorted {
            $0.0 < $1.0
        }
        
        sortedDeadlineArr.append(withoutDeadline)
        
        return sortedDeadlineArr
    }
}
