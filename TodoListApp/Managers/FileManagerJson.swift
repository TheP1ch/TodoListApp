//
//  FileManagerJson.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 19.06.2024.
//

import Foundation

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
