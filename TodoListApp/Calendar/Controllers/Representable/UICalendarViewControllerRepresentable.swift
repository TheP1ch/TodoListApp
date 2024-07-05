//
//  CalendarRepresentable.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 05.07.2024.
//

import SwiftUI

struct UICalendarViewControllerRepresentable: UIViewControllerRepresentable {
    
    @ObservedObject var listViewModel: TodoListViewModel
    
    private var calendarViewModel: CalendarViewModel = CalendarViewModel()
    
    init(listViewModel: TodoListViewModel) {
        self.listViewModel = listViewModel
    }
    
    func makeUIViewController(context: Context) -> CalendarViewController {
        calendarViewModel.update(items: listViewModel.items)
        
        let vc = CalendarViewController(viewModel: calendarViewModel)
        
        return vc
    }
    
    // Changes From SwiftUI to UIKit
    func updateUIViewController(_ uiViewController: CalendarViewController, context: Context) {
        
    }
    
    //Coordinator changes from UIKit to SwiftUI
}
