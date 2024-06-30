//
//  Priority + Extensions.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 30.06.2024.
//

import SwiftUI

extension Priority {
    
    var image: Optional<some View> {
        switch self {
        case .important:
            Image(systemName: "exclamationmark.2")
                .foregroundStyle(ColorTheme.ColorPalette.red.color)
        case .low:
            Image(systemName: "arrow.down")
                .foregroundStyle(ColorTheme.ColorPalette.gray.color)
        case .normal:
            nil
        }
    }
}
