//
//  ContentView.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 17.06.2024.
//

import SwiftUI

struct ContentView: View {
    var fileCache = FileCache()
    var body: some View {
        VStack {
            Button("Add Todo") {
                fileCache.add(todoItem: TodoItem(text: "Item\(fileCache.todoItems.count)", priority: .normal, isCompleted: Bool.random(), creationDate: Date()))
            }
            .foregroundColor(.black)

            .padding()
            Button("Save All") {
                try! fileCache.saveCSVFile(named: "CSV2")
            }
            Button("Load") {
                try! fileCache.loadCSVFile(named: "CSV2")
            }
//            Button("remove"){
//                fileCache.removeTodoItem(id: "1B881E77-72E4-4A70-92D9-A607B7A3AE79")
//            }
            Button("print todoItems") {
                fileCache.todoItems.forEach{
                    print("Todo-\($0.id): \($0)")
                    
                }
                print("//////////////////////")
            }
            .foregroundColor(.black)

        }
        .padding()
//        .onAppear{
//            let todo = TodoItem(text: "Text2", priority: .normal, deadline: Date(), isCompleted: true, creationDate: Date(), lastChangingDate: Date())
//            let todo2 = TodoItem(text: "Text3", priority: .important, deadline: Date(), isCompleted: false, creationDate: Date(), lastChangingDate: Date())
//            print(todo.json)
//            print(todo2.json)
//            print(TodoItem.parse(json: todo.json) ?? 4)
//        }
    }
}

#Preview {
    ContentView()
}
