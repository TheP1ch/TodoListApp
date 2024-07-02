//
//  DetailsSwipeButton.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 02.07.2024.
//

import SwiftUI

struct DetailsSwipeButton: View {
    //MARK: Public Properties
    
    let action: () -> Void
    
    //MARK: Body
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "info.circle.fill")
                .foregroundStyle(
                    ColorTheme.ColorPalette.white.color
                )
        }
        .tint(ColorTheme.ColorPalette.grayLight.color)
    }
}

#Preview {
    DetailsSwipeButton {}
}
