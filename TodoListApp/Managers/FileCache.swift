//
//  FileCache.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 17.06.2024.
//

import Foundation

enum FileError: Error{
    case fileNotFound
    case saveToFileFailed
    case downloadFromFIleFailed
    case parseFailed
}

struct FileCache {
    private(set) var todoItems: [TodoItem] = []

    mutating func addTodoItem(todoItem: TodoItem) {
        for i in 0..<todoItems.count {
            if todoItems[i].id == todoItem.id{
                todoItems[i] = todoItem
                return
            }
        }
        todoItems.append(todoItem)
    }
    
    mutating func removeTodoItem(id: String) {
        for i in 0..<todoItems.count {
            if todoItems[i].id == id {
                todoItems.remove(at: i)
                return
            }
        }
    }
}

extension FileCache {
    mutating func loadFromJsonFile(fileName: String) {
        guard let fileUrl = getFileUrl(fileName: fileName) else {
            print("invalid fileURL")
            return
        }
        
        do {
            let data = try Data(contentsOf: fileUrl)
            guard let jsonData = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {return}
            self.todoItems = jsonData.compactMap{
                TodoItem.parse(json: $0)
            }
            
        } catch {
            print("Error load data from json file: \(error)")
        }
        
    }
    
    func saveAllToJsonFile(fileName: String) {
        guard let fileUrl = getFileUrl(fileName: fileName) else {
            print("invalid fileURL")
            return
        }
        
        let json = todoItems.map {
            $0.json
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json)
            try data.write(to: fileUrl)
        } catch {
            print("failed write to file: \(error)")
        }
    }
}

extension FileCache {
    private func getFileUrl(fileName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else{
            return nil
        }
        
        return url.appending(path: fileName)
    }
}
