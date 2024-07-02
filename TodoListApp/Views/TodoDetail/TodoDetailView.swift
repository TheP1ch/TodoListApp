//
//  TodoDetailView.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 01.07.2024.
//

import SwiftUI

struct TodoDetailView: View {
    private enum HTransitionId: Hashable {
        case textField
        case settingsList
    }
    
    //MARK: Public Properties
    @ObservedObject var viewModel: TodoDetailViewModel
    
    //MARK: Private Properties
    
    @Environment(\.dismiss)
    private var dismiss
    
    @State private var isShowedDatePicker: Bool = false
    
    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass
    
    @Environment(\.verticalSizeClass)
    private var verticalSizeClass
    
    private var isLandscape: Bool {
        verticalSizeClass == .compact || horizontalSizeClass == .regular
    }
    
    @FocusState
    private var isFocused: Bool
    
    @State private var showView: Bool = true
    
    //MARK: Body
    
    var body: some View {
        NavigationStack{
            content
                .scrollContentBackground(.hidden)
                .background(ColorTheme.Back.backPrimary.color)
                .navigationTitle("Дело")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    toolbarContent
                }
        }
    }
    
    //MARK: View Properties
    
    @ViewBuilder
    private var content: some View {
        if isLandscape{
            horizontalLayout
        } else {
            verticalLayout
        }
    }
    
    private var horizontalLayout: some View {
        HStack {
            GeometryReader { geometry in
                List {
                    textFieldCell
                        .focused($isFocused)
                        .frame(minHeight: geometry.size.height - geometry.safeAreaInsets.top - 2 * geometry.safeAreaInsets.bottom, alignment: .topLeading)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            if showView {
                List{
                    Section {
                        importanceCell
                        deadlineCell
                        if isShowedDatePicker {
                            calendarCell
                        }
                    }
                    .alignmentGuide(.listRowSeparatorTrailing, computeValue: { d in
                        d[.trailing]
                    })
                    .listSectionSpacing(16)
                    
                    deleteButton
                }
                .scrollIndicators(.hidden)
            }
        }
        .onChange(of: isFocused) { old, new in
            withAnimation(.easeInOut) {
                showView = !new
            }
        }
    }
    
    
    private var verticalLayout: some View {
        List{
            textFieldCell
            Section {
                importanceCell
                deadlineCell
                if isShowedDatePicker {
                    calendarCell
                }
            }
            .alignmentGuide(.listRowSeparatorTrailing, computeValue: { d in
                d[.trailing]
            })
            .listSectionSpacing(16)
            
            deleteButton
        }
    }
    
    private var textFieldCell: some View {
        TextFieldCell(text: $viewModel.text)
            .listRowBackground(ColorTheme.Back.backSecondary.color)
    }
    
    private var importanceCell: some View {
        ImportanceCell(importance: $viewModel.priority)
            .listRowBackground(ColorTheme.Back.backSecondary.color)
    }
    
    private var deadlineCell: some View {
        DeadlineCell(
            deadline: $viewModel.deadline,
            hasDeadline: $viewModel.hasDeadline
        ) {
            withAnimation{
                isShowedDatePicker.toggle()
            }
        }
            .listRowBackground(ColorTheme.Back.backSecondary.color)
            .onChange(
                of: viewModel.hasDeadline
            ) { old, new in
                if new {
                    viewModel.deadline = Date.tommorow
                } else {
                    withAnimation{
                        isShowedDatePicker = false
                    }
                }
            }
    }
    
    private var calendarCell: some View {
        DatePicker(
            "",
            selection: $viewModel.deadline,
            in: Date()...,
            displayedComponents: .date
        )
            .datePickerStyle(.graphical)
            .listRowBackground(ColorTheme.Back.backSecondary.color)
            .environment(\.locale, Locale(identifier: "ru_Ru"))
    }
    
    private var deleteButton: some View {
        Button {
            viewModel.delete()
            dismiss()
        } label: {
            Text("Удалить")
                .font(AppFont.body.font)
                .foregroundStyle(
                    viewModel.isDeleteDisabled ? ColorTheme.Label.labelTertiary.color : ColorTheme.ColorPalette.red.color
                )
                .frame(maxWidth: .infinity, alignment: .center)
        }
            .disabled(viewModel.isDeleteDisabled)
            .buttonStyle(.borderless)
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
            collectionManager: TodoListViewModel(
                fileCache: FileCache(
                    fileManagerCSV: FileManagerCSV(),
                    fileManagerJson: FileManagerJson()
                )
            )
        )
    )
}
