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
    @State
    private var selectedItems: TodoItem? = nil
    
    //MARK: Body
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .bottom) {
                itemsList
                addNewButton
            }
        }
        .sheet(item: $selectedItems) {
            selectedItems = nil
        } content: {
            TodoDetailView(viewModel: TodoDetailViewModel(todoItem: $0, collectionManager: viewModel))
        }
        
    }
    
    //MARK: View Properties
    private var itemsList: some View {
        List {
            Section{
                ForEach(viewModel.sortedItems) {todoItem in
                    TodoItemCell(todoItem: todoItem) {
                        viewModel.isDoneToggle(for: todoItem)
                    }
                    .onTapGesture {
                        self.selectedItems = todoItem
                    }
                    .listRowBackground(
                        ColorTheme.Back.backSecondary.color
                    )
                    .alignmentGuide(.listRowSeparatorLeading, computeValue: { d in
                        d[.leading] + 36
                    })
                }
                NewItemCell()
                    .onTapGesture {
                        self.selectedItems = TodoItem.new()
                    }
            } header: {
                listHeader
            }
        }
        .navigationTitle("Мои дела")
        .scrollContentBackground(.hidden)
        .background(ColorTheme.Back.backPrimary.color)
        .environment(\.defaultMinListRowHeight, LayoutConstants.minListRowHeight)
        
    }
    
    private var addNewButton: some View {
        AddNewItemButton {
            self.selectedItems = TodoItem.new()
        }
        .padding(.bottom, LayoutConstants.addNewButtonPadding)
    }
    
    private var listHeader: some View {
        ListHeader(
            isDoneCount: viewModel.isDoneCount,
            filterOption: $viewModel.filterOption,
            sortOption: $viewModel.sortOption
        )
        .textCase(nil)
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
