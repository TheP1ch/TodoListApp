//
//  FileManager + Extension.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 18.06.2024.
//

import Foundation

extension FileManager {
    static func getFileUrl(fileName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else{
            return nil
        }
        
        return url.appending(path: fileName)
    }
}
