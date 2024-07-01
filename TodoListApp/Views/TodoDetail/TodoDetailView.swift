//
//  TodoDetailView.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 01.07.2024.
//

import SwiftUI

struct TodoDetailView: View {
    //MARK: Public Properties
    @ObservedObject var viewModel: TodoDetailViewModel
    
    //MARK: Private Properties
    
    @Environment(\.dismiss)
    private var dismiss
    
    //MARK: Body
    
    var body: some View {
        NavigationStack{
            content
                .navigationTitle("Дело")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    toolbarContent
                }
        }
    }
    //MARK: View Properties
    
    private var content: some View {
       verticalLayout
    }
    
    private var verticalLayout: some View {
        VStack{
            List{
                textField
            }
        }
    }

    private var textField: some View {
        TextFieldCell()
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                viewModel.save()
                dismiss()
            } label: {
                Text("Сохранить")
                    .foregroundStyle(
                        viewModel.isSaveDisabled ? ColorTheme.Label.labelTertiary.color : ColorTheme.ColorPalette.blue.color
                    )
            }
            
            .disabled(viewModel.isSaveDisabled)
        }
        
        ToolbarItem(placement: .topBarLeading) {
            Button {
                dismiss()
            } label: {
                Text("Отменить")
            }
        }
    }
}

#Preview {
    TodoDetailView(
        viewModel: TodoDetailViewModel(
            todoItem: TodoItem.new(),
            isNew: true,
            collectionManager: TodoListViewModel(
                fileCache: FileCache(
                    fileManagerCSV: FileManagerCSV(),
                    fileManagerJson: FileManagerJson()
                )
            )
        )
    )
}
