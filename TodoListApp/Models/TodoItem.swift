//
//  TodoItem.swift
//  TodoList
//
//  Created by Евгений Беляков on 16.06.2024.
//

import Foundation

struct TodoItem{
    let id: String
    let text: String
    let creationDate: Date
    let isCompleted: Bool
    let priority: Priority
    let deadline: Date?
    let lastChangingDate: Date?
    
    init(id: String = UUID().uuidString,
         text: String,
         priority: Priority,
         deadline: Date? = nil,
         isCompleted: Bool,
         creationDate: Date,
         lastChangingDate: Date? = nil) {
        self.id = id
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.isCompleted = isCompleted
        self.creationDate = creationDate
        self.lastChangingDate = lastChangingDate
    }
}

enum Priority: String {
    case low = "неважная"
    case normal = "обычная"
    case important = "важная"
}

enum TodoItemKeys: String {
    case id, text, priority, deadline, isCompleted, creationDate, lastChangingDate
}

extension TodoItem{
    var json: Any {
        var dictionary = [String: Any]()
        dictionary[TodoItemKeys.id.rawValue] = self.id
        dictionary[TodoItemKeys.text.rawValue] = self.text
        if self.priority != .normal {
            dictionary[TodoItemKeys.priority.rawValue] = self.priority.rawValue
        }
        if let deadline = self.deadline {
            dictionary[TodoItemKeys.deadline.rawValue] = Int(deadline.timeIntervalSince1970)
        }
        if let lastChangingDate = self.lastChangingDate {
            dictionary[TodoItemKeys.lastChangingDate.rawValue] = Int(lastChangingDate.timeIntervalSince1970)
        }
        dictionary[TodoItemKeys.isCompleted.rawValue] = self.isCompleted
        dictionary[TodoItemKeys.creationDate.rawValue] = Int(self.creationDate.timeIntervalSince1970)
        
        return dictionary
    }
}

extension TodoItem {

    static func parse(json: Any) -> TodoItem? {
        guard let json = json as? [String: Any],
              let id = json[TodoItemKeys.id.rawValue] as? String,
              let text = json[TodoItemKeys.text.rawValue] as? String,
              let isCompleted = json[TodoItemKeys.isCompleted.rawValue] as? Bool,
              let creationDateTimeStamp = json[TodoItemKeys.creationDate.rawValue] as? Int
        else {
            return nil
        }

        let deadline: Date?

        if let deadlineTimeInterval = json[TodoItemKeys.deadline.rawValue] as? Int {
            deadline = Date(timeIntervalSince1970: TimeInterval(deadlineTimeInterval))
        } else {
            deadline = nil
        }
        
        let lastChangingDate: Date?
        if let lastChangingTimeInterval = json[TodoItemKeys.lastChangingDate.rawValue] as? Int {
            lastChangingDate = Date(timeIntervalSince1970: TimeInterval(lastChangingTimeInterval))
        } else {
            lastChangingDate = nil
        }
        
        var priority: Priority
        if let priorityRawValue = json[TodoItemKeys.priority.rawValue] as? String{
            if let priorityValue = Priority(rawValue: priorityRawValue) {
                priority = priorityValue
            } else {
                return nil
            }
        } else {
            priority = .normal
        }

        let creationDate = Date(timeIntervalSince1970: TimeInterval(creationDateTimeStamp))
        
        return TodoItem(
            id: id,
            text: text,
            priority: priority,
            deadline: deadline,
            isCompleted: isCompleted,
            creationDate: creationDate,
            lastChangingDate: lastChangingDate
        )
    }
}



extension TodoItem {
    var csv: String {
        var csvString = "\(self.id),\(self.text),\(Int(self.creationDate.timeIntervalSince1970)),"

        if self.priority != .normal {
            csvString += "\(self.priority.rawValue),"
        }else {
            csvString += ","
        }
        if let deadline = self.deadline {
            csvString += "\(Int(deadline.timeIntervalSince1970)),"
        } else {
            csvString += ","
        }
        if let lastChangingDate = self.lastChangingDate {
            csvString += "\(Int(lastChangingDate.timeIntervalSince1970)),"
        }else {
            csvString += ","
        }

        csvString += "\(self.isCompleted)"
        return csvString
    }
    
    //let id: String
    //let text: String
    //let creationDate: Date
    //let priority: Priority
    //let deadline: Date?
    //let lastChangingDate: Date?
    //let isCompleted: Bool
    
    static func parse(csv: String) -> TodoItem? {
        let csvDataArray = csv.components(separatedBy: ",")
        
        guard csvDataArray.count == 7 else { return nil }
        
        let id = csvDataArray[0]
        let text = csvDataArray[1]
        
        guard let creationDateTimeStamp = Int(csvDataArray[2]) else {
            return nil
        }
        let creationDate = Date(timeIntervalSince1970: TimeInterval(creationDateTimeStamp))
        
        let priority: Priority
        if csvDataArray[3] != ""{
            if let priorityValue = Priority(rawValue: csvDataArray[3]) {
                priority = priorityValue
            } else {
                return nil
            }
        } else {
            priority = .normal
        }
        
        let deadline: Date?
        if let deadlineTimeInterval = Int(csvDataArray[4]) {
            deadline = Date(timeIntervalSince1970: TimeInterval(deadlineTimeInterval))
        } else {
            deadline = nil
        }
        
        let lastChangingDate: Date?
        if let lastChangingTimeInterval = Int(csvDataArray[5]) {
            lastChangingDate = Date(timeIntervalSince1970: TimeInterval(lastChangingTimeInterval))
        } else {
            lastChangingDate = nil
        }
        
        guard let isCompleted = Bool(csvDataArray[6]) else {
            return nil
        }
        
        return TodoItem(
            id: id,
            text: text,
            priority: priority,
            deadline: deadline,
            isCompleted: isCompleted,
            creationDate: creationDate,
            lastChangingDate: lastChangingDate
        )
    }
}
