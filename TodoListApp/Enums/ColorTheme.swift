//
//  ColorTheme.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 29.06.2024.
//

import SwiftUI

enum ColorTheme {
    
    enum Support: String {
        case separator
        case overlay
        case navBarBlur
        
        var color: Color {
            Color(self.rawValue)
        }
    }
}
