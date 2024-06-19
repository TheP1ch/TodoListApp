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
    func saveJsonFile(named fileName: String, json: Any) throws
    func loadJsonFile(named fileName: String) throws -> Any
}

final class FileManagerJson: FileManagingJson {
    func loadJsonFile(named fileName: String) throws -> Any {
        guard let fileUrl = FileManager.getFileUrl(fileName: "\(fileName).json") else {
            throw FileError.invalidFileURL
        }
        
        let data: Data = try Data(contentsOf: fileUrl)
      
        return try JSONSerialization.jsonObject(with: data)
        
    }

    func saveJsonFile(named fileName: String, json: Any) throws {
        guard let fileUrl = FileManager.getFileUrl(fileName: "\(fileName).json") else {
            throw FileError.invalidFileURL
        }
        
        let data: Data = try JSONSerialization.data(withJSONObject: json)
        
        try data.write(to: fileUrl)
    }
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
        todoItems: [TodoItem] = [],
        fileManagerCSV: FileManagingCSV,
        fileManagerJson: FileManagingJson
    ) {
        self.todoItems = todoItems
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
