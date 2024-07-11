//
//  DeleteSwipeButton.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 02.07.2024.
//

import SwiftUI

struct DeleteSwipeButton: View {
    // MARK: Public Properties

    let action: () -> Void

    // MARK: Body

    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "trash.fill")
                .foregroundStyle(
                    ColorTheme.ColorPalette.white.color
                )
        }
        .tint(ColorTheme.ColorPalette.red.color)
    }
}

#Preview {
    DeleteSwipeButton {}
}
