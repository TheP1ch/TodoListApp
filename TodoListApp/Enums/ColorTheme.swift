//
//  ColorTheme.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 29.06.2024.
//

import SwiftUI

protocol ColorConverter {
    var rawValue: String { get }
    
    var color: Color { get }
    
    var uiColor: UIColor {get}
}

extension ColorConverter {
    var color: Color {
        Color(self.rawValue)
    }
    
    var uiColor: UIColor {
        UIColor(self.color)
    }
}

enum ColorTheme {

    enum Support: String, ColorConverter {
        case separator
        case overlay
        case navBarBlur
        case calendarBack
    }
    
    enum Back: String, ColorConverter {
        case backElevated
        case backIOSPrimary
        case backPrimary
        case backSecondary
    }
    
    enum Label: String, ColorConverter {
        case labelDisabled
        case labelPrimary
        case labelSecondary
        case labelTertiary
    }
    
    enum ColorPalette: String, ColorConverter {
        case blue
        case gray
        case grayLight
        case green
        case red
        case white
    }
    
    enum ButtonShadow: String, ColorConverter {
        case addNew
    }
}
