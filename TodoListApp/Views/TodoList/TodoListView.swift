//
//  ContentView.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 17.06.2024.
//

import SwiftUI

fileprivate enum LayoutConstants {
    static let addNewButtonPadding: CGFloat = 20
    static let minListRowHeight: CGFloat = 56
}

struct TodoListView: View {
    //MARK: Public Properties
    @StateObject var viewModel: TodoListViewModel
    
    //MARK: Private Properties
    
    //MARK: Body
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .bottom) {
                itemsList
                addNewButton
            }
        }
    }
    
    //MARK: View Properties
    private var itemsList: some View {
        List {
            Section{
                ForEach(viewModel.items) {todoItem in
                    TodoItemCell(todoItem: todoItem) {
                        viewModel.isDoneToggle(for: todoItem)
                    }
                    .listRowBackground(
                        ColorTheme.Back.backSecondary.color
                    )
                    .alignmentGuide(.listRowSeparatorLeading, computeValue: { d in
                        d[.leading] + 38
                    })
                }
            }
        }
        .navigationTitle("Мои дела")
        .scrollContentBackground(.hidden)
        .background(ColorTheme.Back.backPrimary.color)
        
        .environment(\.defaultMinListRowHeight, LayoutConstants.minListRowHeight)
    }
    
    private var addNewButton: some View {
        AddNewItemButton {
            viewModel.add(item: nil)
            print(viewModel.items.count)
        }
        .padding(.bottom, LayoutConstants.addNewButtonPadding)
    }
}

#Preview {
    TodoListView(
        viewModel: TodoListViewModel(
            fileCache: FileCache(
                fileManagerCSV: FileManagerCSV(),
                fileManagerJson: FileManagerJson()
            )
        )
    )
}
