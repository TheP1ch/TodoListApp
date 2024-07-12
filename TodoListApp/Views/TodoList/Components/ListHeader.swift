//
//  ListHeader.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 01.07.2024.
//

import SwiftUI

struct ListHeader: View {
    // MARK: Public Properties
    var isDoneCount: Int

    @Binding var filterOption: FilterOption

    @Binding var sortOption: SortOption

    // MARK: Body

    var body: some View {
        HStack {
            isDoneText
            Spacer()
            menu
        }
    }
    // MARK: View Properties
    private var isDoneText: some View {
        Text("Выполнено — " + "\(isDoneCount)")
            .font(AppFont.subhead.font)
            .foregroundStyle(
                ColorTheme.Label.labelTertiary.color
            )
    }

    private var menu: some View {
        Menu {
            completeSection
            filterSection
        } label: {
            Text("Фильтр")
                .font(AppFont.subhead.font)
                .foregroundStyle(
                    ColorTheme.ColorPalette.blue.color
                )
        }
    }

    private var completeSection: some View {
        Section("Выполненные") {
            ForEach(FilterOption.allCases, id: \.id) { option in
                Button {
                    filterOption = option
                } label: {
                    Text(option.rawValue)

                    if filterOption == option {
                        Image(systemName: "checkmark")
                    }
                }
                .foregroundStyle(ColorTheme.Label.labelPrimary.color)
            }
        }
    }

    private var filterSection: some View {
        Section("Сортировать по") {
            ForEach(SortOption.allCases, id: \.id) { option in
                Button {
                    sortOption = option
                } label: {
                    Text(option.rawValue)

                    if sortOption == option {
                        Image(systemName: "checkmark")
                    }
                }
                .foregroundStyle(ColorTheme.Label.labelPrimary.color)
            }
        }
    }
}

#Preview {
    ListHeader(isDoneCount: 4, filterOption: .constant(.all), sortOption: .constant(.createdAt))
}
