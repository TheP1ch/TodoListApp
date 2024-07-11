//
//  ContentView.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 17.06.2024.
//

import SwiftUI

private enum Device {
    case iphone
    case ipad
}

struct TodoListView: View {
    // MARK: Public Properties
    @ObservedObject var viewModel: TodoListViewModel

    // MARK: Private Properties
    @State
    private var selectedItems: TodoItem?

    @StateObject
    var categoryViewModel: CategoryViewModel = CategoryViewModel(fileManagerJson: FileManagerJson())

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

    // MARK: Body
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                itemsList
                addNewButton
            }
            .toolbar {
                toolBarItems
            }
        }
        .sheet(item: $selectedItems) {
            selectedItems = nil
        } content: {
            TodoDetailView(
                viewModel: TodoDetailViewModel(
                    todoItem: $0,
                    collectionManager: viewModel
                ),
                categoryViewModel: categoryViewModel
            )
        }

    }

    // MARK: View Properties
    private var itemsList: some View {
        List {
            Section {
                ForEach(viewModel.sortedItems) {todoItem in
                    TodoItemCell(todoItem: todoItem) {
                        viewModel.isCompletedChange(for: todoItem, newValue: $0)
                    }
                    .padding(.trailing, -18)
                    .listRowBackground(
                        ColorTheme.Back.backSecondary.color
                    )
                    .swipeActions(edge: .leading) {
                        SuccessSwipeButton {
                            viewModel.isCompletedChange(for: todoItem, newValue: true)
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
                    .alignmentGuide(.listRowSeparatorLeading, computeValue: { dimensions in
                        dimensions[.leading] + 36
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
        .onAppear {
            try? categoryViewModel.load()
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

    @ToolbarContentBuilder
    private var toolBarItems: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            NavigationLink {
                UICalendarViewControllerRepresentable(listViewModel: viewModel, categoryViewModel: categoryViewModel)
                    .ignoresSafeArea()
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("Мои дела")
            } label: {
                Image(systemName: "calendar")
                    .foregroundStyle(
                         ColorTheme.ColorPalette.blue.color
                    )
            }
        }
    }
}

#Preview {
    TodoListView(
        viewModel: TodoListViewModel(
            fileName: FileCache.fileName,
            format: FileCache.fileExtension,
            fileCache: FileCache()
        )
    )
}
