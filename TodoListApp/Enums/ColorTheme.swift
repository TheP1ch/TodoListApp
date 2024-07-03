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
    
    enum Back: String {
        case backElevated
        case backIOSPrimary
        case backPrimary
        case backSecondary
        
        var color: Color {
            Color(self.rawValue)
        }
    }
    
    enum Label: String {
        case labelDisabled
        case labelPrimary
        case labelSecondary
        case labelTertiary
        
        var color: Color {
            Color(self.rawValue)
        }
    }
    
    enum ColorPalette: String {
        case blue
        case gray
        case grayLight
        case green
        case red
        case white
        
        var color: Color {
            Color(self.rawValue)
        }
    }
    
    enum ButtonShadow: String {
        case addNew
        
        var color: Color {
            Color(self.rawValue)
        }
    }
}
