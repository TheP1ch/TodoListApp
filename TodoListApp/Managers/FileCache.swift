//
//  FileCache.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 17.06.2024.
//

import Foundation

enum FileError: Error {
    case invalidFileURL
    case invalidJsonSearialization
    case invalidStringConvert
}

enum FileFormat {
    case json
    case csv
}

protocol FileManaging {
    var todoItems: [TodoItem] {get}
    
    func add(todoItem: TodoItem)
    func removeItem(by id: String)
    
    func load(fileName: String, format: FileFormat) throws
    func save(fileName: String, format: FileFormat) throws
}

final class FileCache: FileManaging {
    private(set) var todoItems: [TodoItem]
    
    private let fileManagerJson: FileManagingJson
    private let fileManagerCSV: FileManagingCSV
    
    init(
        fileManagerCSV: FileManagingCSV,
        fileManagerJson: FileManagingJson
    ) {
        self.todoItems = [
            TodoItem(id: "test1", text: "description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1", priority: .low, deadline: Date(timeIntervalSince1970: 10000), isCompleted: true, createdAt: Date(timeIntervalSince1970: 101), changeAt: Date(timeIntervalSince1970: 500)),
            TodoItem(id: "test2", text: "Задание 1", priority: .normal, deadline: Date(timeIntervalSince1970: 10000), isCompleted: false, createdAt: Date(timeIntervalSince1970: 100), changeAt: Date(timeIntervalSince1970: 500)),
            TodoItem(id: "test3", text: "description3", priority: .important, deadline: Date(timeIntervalSince1970: 10000), isCompleted: false, createdAt: Date(timeIntervalSince1970: 102), changeAt: Date(timeIntervalSince1970: 500)),
            TodoItem(id: "test4", text: "description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1description1", priority: .normal, deadline: Date(timeIntervalSince1970: 10000), isCompleted: false, createdAt: Date(timeIntervalSince1970: 100), changeAt: Date(timeIntervalSince1970: 500))
        ]
        self.fileManagerJson = fileManagerJson
        self.fileManagerCSV = fileManagerCSV
    }
    
    func add(todoItem: TodoItem) {
        for i in 0..<todoItems.count {
            if todoItems[i].id == todoItem.id{
                todoItems[i] = todoItem
                return
            }
        }
        todoItems.append(todoItem)
    }
    
    func removeItem(by id: String) {
        for i in 0..<todoItems.count {
            if todoItems[i].id == id {
                todoItems.remove(at: i)
                return
            }
        }
    }
    
    func load(fileName: String, format: FileFormat) throws {
        switch format {
        case .csv:
            let csvStr = try self.fileManagerCSV.loadCSVFile(named: fileName)
            let csvData = csvStr.components(separatedBy: "\n")
            self.todoItems = csvData.compactMap{
                    TodoItem.parse(csv: $0)
            }
        case .json:
            guard let jsonData = try self.fileManagerJson.loadJsonFile(named: fileName) as? [[String: Any]] else {
                throw FileError.invalidJsonSearialization
            }
            self.todoItems = jsonData.compactMap{
                    TodoItem.parse(json: $0)
            }
        }
    }
    
    func save(fileName: String, format: FileFormat) throws {
        switch format{
        case .csv:
            let csvString = todoItems.reduce("") {str, item in
                str + "\(item.csv)\n"
            }
            try self.fileManagerCSV.saveCSVFile(named: fileName, data: csvString)
        case .json:
            let json = todoItems.map {
                $0.json
            }
            
            try self.fileManagerJson.saveJsonFile(named: fileName, json: json)
        }
    }
}
