//
//  CategoryColorCircle.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 06.07.2024.
//

import SwiftUI

struct CategoryColorCircle: View {
    @State var color: Color

    var body: some View {
        Circle()
            .frame(width: 24, height: 24)
            .foregroundStyle(color)

    }
}

#Preview {
    CategoryColorCircle(color: .red)
}
