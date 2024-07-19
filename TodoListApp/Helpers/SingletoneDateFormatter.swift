//
//  CustomDateFormmater.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 19.07.2024.
//

import Foundation

final class SingletoneDateFormatter {
    public static let shared = SingletoneDateFormatter()

    private let dateFormatter: DateFormatter

    private init() {
        dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
    }

    func toString(date: Date, format: String = "dd MMMM") -> String {
        dateFormatter.dateFormat = format
        let string = dateFormatter.string(from: date)

        return string
    }
}
