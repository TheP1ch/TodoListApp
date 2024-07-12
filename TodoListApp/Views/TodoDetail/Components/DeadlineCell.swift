//
//  DeadlineCell.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 02.07.2024.
//

import SwiftUI

struct DeadlineCell: View {
    // MARK: Public Properties
    @Binding var deadline: Date

    @Binding var hasDeadline: Bool

    var onTap: () -> Void

    // MARK: Body

    var body: some View {
        Toggle(isOn: $hasDeadline) {
            VStack {
                Text("Сделать до")
                    .font(AppFont.body.font)
                    .foregroundStyle(ColorTheme.Label.labelPrimary.color)

                if hasDeadline {
                    deadlineTitle
                }
            }
        }
    }

    // MARK: View Properties

    private var deadlineTitle: some View {
        Button {
            onTap()
        } label: {
            Text("\(deadline.toString(with: "dd MMMM YYYY"))")
                .font(AppFont.footnote.font)
                .foregroundStyle(ColorTheme.ColorPalette.blue.color)
        }
    }
}

#Preview {
    DeadlineCell(
        deadline: .constant(Date.tommorow),
        hasDeadline: .constant(true)
    ) {
        print("deadline \(Date.tommorow)")
    }
}
