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

protocol FileManagingJson {
    func saveJsonFile(named fileName: String) throws
    func loadJsonFile(named fileName: String) throws
}

protocol FileManagingCSV {
    func saveCSVFile(named fileName: String) throws
    func loadCSVFile(named fileName: String) throws
}

protocol FileManaging {
    var todoItems: [TodoItem] {get}
    
    func add(todoItem: TodoItem)
    func removeItem(by id: String)
    func load(fileName: String, format: FileFormat)
    func save(fileName: String, format: FileFormat)
}

final class FileCache: FileManaging, FileManagingCSV, FileManagingJson {
    private(set) var todoItems: [TodoItem] = []
    
    private let fileManager: FileManager
    
    init(
        todoItems: [TodoItem],
        fileManager: FileManager
    ) {
        self.todoItems = todoItems
        self.fileManager = fileManager
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
}

extension FileCache {
    
    func loadJsonFile(named fileName: String) throws {
    
        guard let fileUrl = FileManager.getFileUrl(fileName: "\(fileName).json") else {
            throw FileError.invalidFileURL
        }
        
        let data: Data = try Data(contentsOf: fileUrl)
      
        guard let jsonData = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
                throw FileError.invalidJsonSearialization
        }
        self.todoItems = jsonData.compactMap{
                TodoItem.parse(json: $0)
        }
        
    }

    func saveJsonFile(named fileName: String) throws {
        guard let fileUrl = FileManager.getFileUrl(fileName: "\(fileName).json") else {
            throw FileError.invalidFileURL
        }
        
        let json = todoItems.map {
            $0.json
        }
        
        let data: Data = try JSONSerialization.data(withJSONObject: json)
        
        try data.write(to: fileUrl)
    }
}

extension FileCache {
    func saveCSVFile(named fileName: String) throws {
        guard let fileUrl = FileManager.getFileUrl(fileName: "\(fileName).csv") else {
            throw FileError.invalidFileURL
        }
        
        let csvString = todoItems.reduce("") {str, item in
            str + "\(item.csv)\n"
        }
        
        try csvString.write(to: fileUrl, atomically: true, encoding: .utf8)
    }
    
    func loadCSVFile(named fileName: String) throws {
        guard let fileUrl = FileManager.getFileUrl(fileName: "\(fileName).csv") else {
            throw FileError.invalidFileURL
        }
        
        let data: Data = try Data(contentsOf: fileUrl)
        guard let csvStr = String(data: data, encoding: .utf8) else{
            throw FileError.invalidStringConvert
        }
        
        let csvData = csvStr.components(separatedBy: "\n")
        self.todoItems = csvData.compactMap{
                TodoItem.parse(csv: $0)
        }
    }
}
