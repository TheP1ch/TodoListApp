//
//  CategoryViewModel.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 06.07.2024.
//

import SwiftUI

final class CategoryViewModel: ObservableObject {
    
    @Published private(set) var categories: [Category] = Category.unchangableCategories
    
    var categoriesDict: [String: Category] {
        var dict: [String: Category] = [:]
        
        categories.forEach {
            if dict[$0.id] == nil {
                dict[$0.id] = $0
            } else {
                dict[$0.id] = $0
            }
        }
        
        return dict
    }
    
    
    private let fileManagerJson: FileManagerJson
    
    init(fileManagerJson: FileManagerJson) {
        self.fileManagerJson = fileManagerJson
    }
    
    func add(category: Category){
        categories.append(category)
        
        save()
    }
    
    private func save() {
        let jsonEncode = JSONEncoder()
        guard let json = try? jsonEncode.encode(categories) else { return }
        
        
        try? fileManagerJson.save(fileName: "categories", json: json)
    }
    
    func load() throws {
        
        let json = try fileManagerJson.load(fileName: "categories")
        
        let jsonDecoder = JSONDecoder()
        let data = try jsonDecoder.decode([Category].self, from: json)
        
        categories = data
    }
}
