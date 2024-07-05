//
//  TodoItemCell.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 30.06.2024.
//

import SwiftUI

struct TodoItemCell: View {
    //MARK: Public Properties
    var todoItem: TodoItem
    var onDoneButtonTap: () -> Void
    
    private var color: Color? {
        if let hexColor = todoItem.hexColor, let color = Color(hex: hexColor) {
            return color
        }
        
        return nil
    }
    
    //MARK: Body
    
    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 12){
                doneButton
                HStack(spacing: 2){
                    colorLine
                    if let priorityImage = todoItem.priority.image, !todoItem.isCompleted {
                        priorityImage
                    }
                    
                    VStack(alignment: .leading) {
                        itemText
                        if let _ = todoItem.deadline{
                            deadlineLabel
                        }
                    }
                }
            }
            Spacer()
            chevroneImage
        }
    }
    
    //MARK: View Properties
    
    private var itemText: some View{
        Text(todoItem.text)
            .font(AppFont.body.font)
            .foregroundStyle(
                todoItem.isCompleted ? ColorTheme.Label.labelTertiary.color : ColorTheme.Label.labelPrimary.color
            )
            .lineLimit(3)
            .strikethrough(todoItem.isCompleted, pattern: .solid)
    }
    
    private var colorLine: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(color ?? ColorTheme.Back.backSecondary.color)
            .frame(width: 4)
    }
    
    private var doneButton: some View {
        Button {
            onDoneButtonTap()
        } label: {
            if todoItem.isCompleted{
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .foregroundStyle(
                        ColorTheme.ColorPalette.white.color,
                        .white,
                        ColorTheme.ColorPalette.green.color
                    )
                    .clipShape(.circle)
            } else if todoItem.priority == .important {
                Image(systemName: "circle")
                    .resizable()
                    .foregroundStyle(ColorTheme.ColorPalette.red.color)
                    .background(ColorTheme.ColorPalette.red.color.opacity(0.1))
                    .clipShape(.circle)
                
            } else {
                Image(systemName: "circle")
                    .resizable()
                    .foregroundStyle(ColorTheme.Support.separator.color)
            }
        }.frame(width: 24, height: 24)
            .buttonStyle(.plain)
        
    }
    
    private var chevroneImage: some View {
        Image(systemName: "chevron.right")
            .foregroundStyle(ColorTheme.ColorPalette.gray.color)
            .padding(.trailing, 16)
    }
    
    private var deadlineLabel: some View {
        HStack(spacing: 2) {
            Image(systemName: "calendar")
            if let deadline = todoItem.deadline{
                Text(deadline.toString())
                    .font(AppFont.subhead.font)
            }
            
                
        }
        .foregroundStyle(ColorTheme.Label.labelTertiary.color)
    }
}

#Preview {
    TodoItemCell(todoItem: TodoItem(text: "gege", priority: .important, hexColor: "#FF3B30"),
                 onDoneButtonTap: {
        print("tap btn")
    })
}
