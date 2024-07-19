//
//  Priority + Extensions.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 30.06.2024.
//

import SwiftUI

extension Priority {

    var image: (some View)? {
        switch self {
        case .important:
            Image(systemName: "exclamationmark.2")
                .font(AppFont.subheadBold.font)
                .foregroundStyle(ColorTheme.ColorPalette.red.color, .white)
        case .low:
            Image(systemName: "arrow.down")
                .font(AppFont.subheadBold.font)
                .foregroundStyle(ColorTheme.ColorPalette.gray.color, .white)
        case .basic:
            nil
        }
    }
}

extension Priority {
    var id: Self { self }
}
