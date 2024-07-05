//
//  ContentView.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 17.06.2024.
//

import SwiftUI

fileprivate enum Device {
    case iphone
    case ipad
}

struct TodoListView: View {
    //MARK: Public Properties
    @ObservedObject var viewModel: TodoListViewModel
    
    //MARK: Private Properties
    @State
    private var selectedItems: TodoItem? = nil
    
    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass
    
    @Environment(\.verticalSizeClass)
    private var verticalSizeClass
    
    private var device: Device {
        if verticalSizeClass == .regular && horizontalSizeClass == .regular {
            return .ipad
        }
        
        return .iphone
    }
    
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
                    .padding(.trailing, -18)
                    .listRowBackground(
                        ColorTheme.Back.backSecondary.color
                    )
                    .swipeActions(edge: .leading) {
                        SuccessSwipeButton {
                            viewModel.isDoneToggle(for: todoItem)
                        }
                    }
                    
                    .swipeActions(edge: .trailing) {
                        DeleteSwipeButton {
                            viewModel.remove(by: todoItem.id)
                        }
                        DetailsSwipeButton {
                            self.selectedItems = todoItem
                        }
                    }
                    .alignmentGuide(.listRowSeparatorLeading, computeValue: { d in
                        d[.leading] + 36
                    })
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.selectedItems = todoItem
                    }
                }
                NewItemCell()
                    .contentShape(Rectangle())
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
        .environment(\.defaultMinListRowHeight, 56)
        .animation(.easeInOut, value: viewModel.sortedItems)
        
    }
    
    private var addNewButton: some View {
        AddNewItemButton {
            self.selectedItems = TodoItem.new()
        }
        .padding(.bottom, 20)
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
            fileName: FileCache.fileName,
            format: FileCache.fileExtension,
            fileCache: FileCache(
                fileManagerCSV: FileManagerCSV(),
                fileManagerJson: FileManagerJson()
            )
        )
    )
}
