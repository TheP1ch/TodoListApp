//
//  FileCache.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 17.06.2024.
//

import FileManaging
import Foundation

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
    static let fileName: String = "TodoItems"
    static let fileExtension: FileFormat = .json

    private(set) var todoItems: [TodoItem]

    private let fileManagerJson: FileManagingJson
    private let fileManagerCSV: FileManagingCSV

    init(
        fileManagerCSV: FileManagingCSV = FileManagerCSV(),
        fileManagerJson: FileManagingJson = FileManagerJson()
    ) {
        self.todoItems = []
        self.fileManagerJson = fileManagerJson
        self.fileManagerCSV = fileManagerCSV
    }

    func add(todoItem: TodoItem) {
        for i in 0..<todoItems.count {
            if todoItems[i].id == todoItem.id {
                todoItems[i] = todoItem
                return
            }
        }
        todoItems.append(todoItem)

        Logger.log("Item add", level: .debug)
    }

    func removeItem(by id: String) {
        for i in 0..<todoItems.count {
            if todoItems[i].id == id {
                todoItems.remove(at: i)
                return
            }
        }

        Logger.log("Item removed", level: .debug)
    }

    func load(fileName: String, format: FileFormat) throws {
        switch format {
        case .csv:
            let csvStr = try self.fileManagerCSV.loadCSVFile(named: fileName)
            let csvData = csvStr.components(separatedBy: "\n")
            self.todoItems = csvData.compactMap {
                    TodoItem.parse(csv: $0)
            }
        case .json:
            guard let jsonData = try self.fileManagerJson.loadJsonFile(named: fileName) as? [[String: Any]] else {
                Logger.log("load data invalid JsonSearialization", level: .error)
                throw FileError.invalidJsonSearialization
            }
            self.todoItems = jsonData.compactMap {
                    TodoItem.parse(json: $0)
            }
        }
    }

    func save(fileName: String, format: FileFormat) throws {
        switch format {
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
