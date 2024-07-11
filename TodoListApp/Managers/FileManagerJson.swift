//
//  FileManagerJson.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 19.06.2024.
//

import Foundation

protocol FileManagingJson {
    func saveJsonFile(named fileName: String, json: Any) throws
    func save(fileName: String, json: Data) throws

    func load(fileName: String) throws -> Data
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

    func load(fileName: String) throws -> Data {
        guard let fileUrl = FileManager.getFileUrl(fileName: "\(fileName).json") else {
            throw FileError.invalidFileURL
        }

        let data: Data = try Data(contentsOf: fileUrl)

        return data
    }

    func save(fileName: String, json: Data) throws {
        guard let fileUrl = FileManager.getFileUrl(fileName: "\(fileName).json") else {
            throw FileError.invalidFileURL
        }

        try json.write(to: fileUrl)
    }

    func saveJsonFile(named fileName: String, json: Any) throws {
        guard let fileUrl = FileManager.getFileUrl(fileName: "\(fileName).json") else {
            throw FileError.invalidFileURL
        }

        let data: Data = try JSONSerialization.data(withJSONObject: json)

        try data.write(to: fileUrl)
    }
}
