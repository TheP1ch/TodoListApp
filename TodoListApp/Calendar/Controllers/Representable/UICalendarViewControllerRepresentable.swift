//
//  CalendarRepresentable.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 05.07.2024.
//

import SwiftUI

protocol CoordinatorDelegate: TaskComplitionDelegate, CollectionManaging {}

protocol TaskComplitionDelegate: AnyObject{
    func complete(item: TodoItem)
    
    func uncomplete(item: TodoItem)
}

struct UICalendarViewControllerRepresentable: UIViewControllerRepresentable {
    
    @ObservedObject var listViewModel: TodoListViewModel
    
    private var calendarViewModel: CalendarViewModel = CalendarViewModel()
    
    init(listViewModel: TodoListViewModel) {
        self.listViewModel = listViewModel
    }
    
    func makeUIViewController(context: Context) -> CalendarViewController {
        let vc = CalendarViewController(viewModel: calendarViewModel)
        vc.delegate = context.coordinator
        
        return vc
    }
    
    // Changes From SwiftUI to UIKit
    func updateUIViewController(_ uiViewController: CalendarViewController, context: Context) {
        uiViewController.updateUI(items: listViewModel.items)
    }
    
    //Coordinator changes from UIKit to SwiftUI
    func makeCoordinator() -> Coordinator {
        Coordinator(listViewModel: self.listViewModel)
    }
    
    final class Coordinator: CoordinatorDelegate {
        @ObservedObject var listViewModel: TodoListViewModel
        
        init(listViewModel: TodoListViewModel) {
            self.listViewModel = listViewModel
        }
        
        func add(item: TodoItem) {
            listViewModel.add(item: item)
        }
        
        func remove(by id: String) {
            listViewModel.remove(by: id)
        }
        
        func complete(item: TodoItem) {
            listViewModel.isCompletedChange(for: item, newValue: true)
        }
        
        func uncomplete(item: TodoItem) {
            listViewModel.isCompletedChange(for: item, newValue: false)
        }
        
        
    }
}

#Preview{
    UICalendarViewControllerRepresentable(
        listViewModel: TodoListViewModel(
            fileName: FileCache.fileName,
            format: FileCache.fileExtension,
            fileCache: FileCache(
                fileManagerCSV: FileManagerCSV(),
                fileManagerJson: FileManagerJson()
            )
        )
    )
}
