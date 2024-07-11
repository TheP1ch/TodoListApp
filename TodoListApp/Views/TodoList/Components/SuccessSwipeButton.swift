//
//  SuccessSwipeButton.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 02.07.2024.
//

import SwiftUI

struct SuccessSwipeButton: View {
    // MARK: Public Properties

    let action: () -> Void

    // MARK: Body

    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(
                    ColorTheme.ColorPalette.green.color,
                    ColorTheme.ColorPalette.white.color
                )
        }
        .tint(ColorTheme.ColorPalette.green.color)
    }
}

#Preview {
    SuccessSwipeButton {}
}
