//
//  FileCache.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 17.06.2024.
//

import Foundation

enum FileError: Error{
    case invalidFileURL
    case fileNotFound
    case loadFileFailed
    case saveFileFailed
    case invalidJson
    case invalidJsonParse
}

protocol FileManaging{
    var todoItems: [TodoItem] {get}
    func add(todoItem: TodoItem)
    func removeItem(by id: String)
}

final class FileCache: FileManaging {
    private(set) var todoItems: [TodoItem] = []

    func add(todoItem: TodoItem) { // Нейминг
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
        guard let fileUrl = FileManager.getFileUrl(fileName: fileName) else {
            throw FileError.invalidFileURL
        }
        
        let data: Data
        do {
             data = try Data(contentsOf: fileUrl)
        } catch {
            throw FileError.fileNotFound
        }
        
        do {       
            guard let jsonData = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
                return
            }
            self.todoItems = jsonData.compactMap{
                TodoItem.parse(json: $0)
            }
            
        } catch {
            throw FileError.invalidJsonParse
        }
        
    }

    func saveJsonFile(named fileName: String) throws {
        guard let fileUrl = FileManager.getFileUrl(fileName: fileName) else {
            print("invalid fileURL")
            return
        }
        
        let json = todoItems.map {
            $0.json
        }
        
        let data: Data
        do {
             data = try JSONSerialization.data(withJSONObject: json)
        } catch {
            throw FileError.invalidJson
        }
        
        do {
            try data.write(to: fileUrl)
        } catch {
            throw FileError.saveFileFailed
        }
    }
}
