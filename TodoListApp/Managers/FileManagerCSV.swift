//
//  FileManagerCSV.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 19.06.2024.
//

import Foundation

protocol FileManagingCSV {
    func saveCSVFile(named fileName: String, data csvString: String) throws
    func loadCSVFile(named fileName: String) throws -> String
}

final class FileManagerCSV: FileManagingCSV{
    func saveCSVFile(named fileName: String, data csvString: String) throws {
        guard let fileUrl = FileManager.getFileUrl(fileName: "\(fileName).csv") else {
            throw FileError.invalidFileURL
        }
        
        try csvString.write(to: fileUrl, atomically: true, encoding: .utf8)
    }
    
    func loadCSVFile(named fileName: String) throws -> String {
        guard let fileUrl = FileManager.getFileUrl(fileName: "\(fileName).csv") else {
            throw FileError.invalidFileURL
        }
        
        let data: Data = try Data(contentsOf: fileUrl)
        guard let csvStr = String(data: data, encoding: .utf8) else{
            throw FileError.invalidStringConvert
        }
        
        return csvStr
    }
}
