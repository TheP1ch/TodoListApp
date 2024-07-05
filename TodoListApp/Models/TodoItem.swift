//
//  TodoItem.swift
//  TodoList
//
//  Created by Евгений Беляков on 16.06.2024.
//

import Foundation

struct TodoItem: Identifiable, Equatable{
    let id: String
    let text: String
    let createdAt: Date
    let isCompleted: Bool
    let priority: Priority
    let deadline: Date?
    let changeAt: Date?
    let hexColor: String?
    
    init(id: String = UUID().uuidString,
         text: String,
         priority: Priority,
         deadline: Date? = nil,
         isCompleted: Bool = false,
         createdAt: Date = Date.now,
         changeAt: Date? = nil,
         hexColor: String? = nil) {
        self.id = id
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.changeAt = changeAt
        self.hexColor = hexColor
    }
}

enum TodoItemKeys: String {
    case id, text, priority, deadline, isCompleted, createdAt, changeAt, hexColor
}

extension TodoItem {
    static func new() -> Self {
        TodoItem(
            text: "test 1 linetest 1 linetest 1 linetest 1 linetest 1 linetest 1 line",
            priority: .normal
        )
    }
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
        if let changeAt = self.changeAt {
            dictionary[TodoItemKeys.changeAt.rawValue] = Int(changeAt.timeIntervalSince1970)
        }
        if let hexColor = self.hexColor{
            dictionary[TodoItemKeys.hexColor.rawValue] = hexColor
        }
        dictionary[TodoItemKeys.isCompleted.rawValue] = self.isCompleted
        dictionary[TodoItemKeys.createdAt.rawValue] = Int(self.createdAt.timeIntervalSince1970)
        
        return dictionary
    }
}

extension TodoItem {

    static func parse(json: Any) -> TodoItem? {
        guard let json = json as? [String: Any],
              let id = json[TodoItemKeys.id.rawValue] as? String,
              let text = json[TodoItemKeys.text.rawValue] as? String,
              let isCompleted = json[TodoItemKeys.isCompleted.rawValue] as? Bool,
              let creationDateTimeStamp = json[TodoItemKeys.createdAt.rawValue] as? Int
        else {
            return nil
        }

        let deadline: Date?

        if let deadlineTimeInterval = json[TodoItemKeys.deadline.rawValue] as? Int {
            deadline = Date(timeIntervalSince1970: TimeInterval(deadlineTimeInterval))
        } else {
            deadline = nil
        }
        
        let changeAt: Date?
        if let changeAtTimeInterval = json[TodoItemKeys.changeAt.rawValue] as? Int {
            changeAt = Date(timeIntervalSince1970: TimeInterval(changeAtTimeInterval))
        } else {
            changeAt = nil
        }
        
        let hexColor = json[TodoItemKeys.hexColor.rawValue] as? String
        
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

        let createdAt = Date(timeIntervalSince1970: TimeInterval(creationDateTimeStamp))
        
        return TodoItem(
            id: id,
            text: text,
            priority: priority,
            deadline: deadline,
            isCompleted: isCompleted,
            createdAt: createdAt,
            changeAt: changeAt,
            hexColor: hexColor
        )
    }
}



extension TodoItem {
    var csv: String {
        var csvString = "\(self.id),\(self.text),\(Int(self.createdAt.timeIntervalSince1970)),"

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
        if let hexColor = self.hexColor {
            csvString += "\(hexColor)),"
        } else {
            csvString += ","
        }
        if let changeAt = self.changeAt {
            csvString += "\(Int(changeAt.timeIntervalSince1970)),"
        }else {
            csvString += ","
        }

        csvString += "\(self.isCompleted)"
        return csvString
    }
    
    static func parse(csv: String) -> TodoItem? {
        let csvDataArray = csv.components(separatedBy: ",")
        
        guard csvDataArray.count == 8 else { return nil }
        
        let id = csvDataArray[0]
        let text = csvDataArray[1]
        
        guard let creationDateTimeStamp = Int(csvDataArray[2]) else {
            return nil
        }
        let createdAt = Date(timeIntervalSince1970: TimeInterval(creationDateTimeStamp))
        
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
        
        let hexColor: String?
        if csvDataArray[5] != ""  {
            hexColor = csvDataArray[3]
        } else {
            hexColor = nil
        }
        
        let changeAt: Date?
        if let changeAtTimeInterval = Int(csvDataArray[6]) {
            changeAt = Date(timeIntervalSince1970: TimeInterval(changeAtTimeInterval))
        } else {
            changeAt = nil
        }
        
        guard let isCompleted = Bool(csvDataArray[7]) else {
            return nil
        }
        
        return TodoItem(
            id: id,
            text: text,
            priority: priority,
            deadline: deadline,
            isCompleted: isCompleted,
            createdAt: createdAt,
            changeAt: changeAt,
            hexColor: hexColor
        )
    }
}
