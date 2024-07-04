//
//  Font.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 29.06.2024.
//

import SwiftUI

enum AppFont {
    case largeTitle
    case title
    case headline
    case body
    case subhead
    case subheadBold
    case footnote
    
    var font: Font {
        switch self {
        case .largeTitle:
            Font.system(size: 38, weight: .bold)
        case .title:
            Font.system(size: 20, weight: .semibold)
        case .headline:
            Font.system(size: 17, weight: .semibold)
        case .body:
            Font.system(size: 17, weight: .regular)
        case .subhead:
            Font.system(size: 15, weight: .regular)
        case .subheadBold:
            Font.system(size: 15, weight: .bold)
        case .footnote:
            Font.system(size: 13, weight: .semibold)
        }
    }
}
