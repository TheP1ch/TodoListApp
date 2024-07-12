//
//  NewItemCell.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 01.07.2024.
//

import SwiftUI

struct NewItemCell: View {

    // MARK: Body
    var body: some View {
        HStack(spacing: 12) {
            Spacer()
                .frame(width: 24)
            Text("Новое")
                .font(AppFont.body.font)
                .foregroundStyle(
                    ColorTheme.Label.labelTertiary.color
                )
            Spacer()
        }
    }
}

#Preview {
    NewItemCell()
}
