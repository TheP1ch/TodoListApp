//
//  TodoItem.swift
//  TodoList
//
//  Created by Евгений Беляков on 16.06.2024.
//

import Foundation
import UIKit

struct TodoItem: Identifiable, Equatable, Codable {
    let id: String
    let text: String
    let createdAt: Date
    let isCompleted: Bool
    let priority: Priority
    let deadline: Date?
    let changeAt: Date
    let hexColor: String?
    let category: String?
    let lastUpdatedBy: String?

    init(id: String = UUID().uuidString,
         text: String,
         priority: Priority,
         deadline: Date? = nil,
         isCompleted: Bool = false,
         createdAt: Date = Date.now,
         changeAt: Date = Date.now,
         hexColor: String? = nil,
         category: String? = nil,
         lastUpdatedBy: String? = UIDevice.current.identifierForVendor?.uuidString) {
        self.id = id
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.changeAt = changeAt
        self.hexColor = hexColor
        self.category = category
        self.lastUpdatedBy = lastUpdatedBy
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case text = "text"
        case priority = "importance"
        case deadline = "deadline"
        case isCompleted = "done"
        case createdAt = "created_at"
        case changeAt = "changed_at"
        case hexColor = "color"
        case category = "category"
        case lastUpdatedBy = "last_updated_by"
    }
}

extension TodoItem {
    static func new() -> Self {
        TodoItem(
            text: "",
            priority: .basic
        )
    }
}

extension TodoItem {
    var json: Any {
        var dictionary = [String: Any]()
        dictionary[CodingKeys.id.rawValue] = self.id
        dictionary[CodingKeys.text.rawValue] = self.text
        dictionary[CodingKeys.changeAt.rawValue] = Int(changeAt.timeIntervalSince1970)
        if self.priority != .basic {
            dictionary[CodingKeys.priority.rawValue] = self.priority.rawValue
        }
        if let deadline = self.deadline {
            dictionary[CodingKeys.deadline.rawValue] = Int(deadline.timeIntervalSince1970)
        }

        if let hexColor = self.hexColor {
            dictionary[CodingKeys.hexColor.rawValue] = hexColor
        }
        if let category = self.category {
            dictionary[CodingKeys.category.rawValue] = category
        }
        dictionary[CodingKeys.isCompleted.rawValue] = self.isCompleted
        dictionary[CodingKeys.createdAt.rawValue] = Int(self.createdAt.timeIntervalSince1970)

        return dictionary
    }
}

extension TodoItem {

    static func parse(json: Any) -> TodoItem? {
        guard let json = json as? [String: Any],
              let id = json[CodingKeys.id.rawValue] as? String,
              let text = json[CodingKeys.text.rawValue] as? String,
              let isCompleted = json[CodingKeys.isCompleted.rawValue] as? Bool,
              let creationDateTimeStamp = json[CodingKeys.createdAt.rawValue] as? Int,
              let changeAtTimeStamp = json[CodingKeys.changeAt.rawValue] as? Int
        else {
            Logger.log("TodoItem parse error json: \(json)", level: .warning)

            return nil
        }

        let deadline: Date?

        if let deadlineTimeInterval = json[CodingKeys.deadline.rawValue] as? Int {
            deadline = Date(timeIntervalSince1970: TimeInterval(deadlineTimeInterval))
        } else {
            deadline = nil
        }

        let changeAt = Date(timeIntervalSince1970: TimeInterval(changeAtTimeStamp))

        let hexColor = json[CodingKeys.hexColor.rawValue] as? String

        let category = json[CodingKeys.category.rawValue] as? String

        var priority: Priority
        if let priorityRawValue = json[CodingKeys.priority.rawValue] as? String {
            if let priorityValue = Priority(rawValue: priorityRawValue) {
                priority = priorityValue
            } else {
                return nil
            }
        } else {
            priority = .basic
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
            hexColor: hexColor,
            category: category
        )
    }
}

extension TodoItem {
    var csv: String {
        var csvString = "\(self.id),\(self.text),\(Int(self.createdAt.timeIntervalSince1970)),"

        if self.priority != .basic {
            csvString += "\(self.priority.rawValue),"
        } else {
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
        if let category = self.category {
            csvString += "\(category)),"
        } else {
            csvString += ","
        }

        csvString += "\(Int(changeAt.timeIntervalSince1970)),"
        csvString += "\(self.isCompleted)"
        return csvString
    }

    // swiftlint:disable function_body_length
    static func parse(csv: String) -> TodoItem? {
        let csvDataArray = csv.components(separatedBy: ",")

        guard csvDataArray.count == 9 else { return nil }

        let id = csvDataArray[0]
        let text = csvDataArray[1]

        guard let creationDateTimeStamp = Int(csvDataArray[2]) else {
            return nil
        }
        let createdAt = Date(timeIntervalSince1970: TimeInterval(creationDateTimeStamp))

        let priority: Priority
        if csvDataArray[3].isEmpty {
            if let priorityValue = Priority(rawValue: csvDataArray[3]) {
                priority = priorityValue
            } else {
                return nil
            }
        } else {
            priority = .basic
        }

        let deadline: Date?
        if let deadlineTimeInterval = Int(csvDataArray[4]) {
            deadline = Date(timeIntervalSince1970: TimeInterval(deadlineTimeInterval))
        } else {
            deadline = nil
        }

        let hexColor: String?
        if csvDataArray[5].isEmpty {
            hexColor = csvDataArray[5]
        } else {
            hexColor = nil
        }

        let category: String?
        if csvDataArray[6].isEmpty {
            category = csvDataArray[6]
        } else {
            category = nil
        }

        guard let changeAtDateTimeStamp = Int(csvDataArray[7]) else {
            return nil
        }
        let changeAt = Date(timeIntervalSince1970: TimeInterval(changeAtDateTimeStamp))

        guard let isCompleted = Bool(csvDataArray[8]) else {
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
            hexColor: hexColor,
            category: category
        )
    }
    // swiftlint:enable function_body_length
}
