//
//  ImportanceCell.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 02.07.2024.
//

import SwiftUI

struct ImportanceCell: View {
    // MARK: Public Properties
    @Binding var importance: Priority

    // MARK: Body

    var body: some View {
        HStack {
            Text("Важность")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(AppFont.body.font)
            picker
        }
    }

    // MARK: View Properties

    private var picker: some View {
        Picker("Test", selection: $importance) {
            ForEach(
                Priority.allCases,
                id: \.id
            ) { item in
                if let imageView = item.image {
                    imageView
                } else {
                    Text("нет")
                }
            }
        }
        .pickerStyle(.segmented)
    }
}

#Preview {
    ImportanceCell(importance: .constant(.low))
}
