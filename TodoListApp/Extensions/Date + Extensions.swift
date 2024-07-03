//
//  Date + Extensions.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 30.06.2024.
//

import Foundation

extension Date {
    func toString(with format: String = "dd MMMM") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let string = dateFormatter.string(from: self)

        return string
    }
    
    static var tommorow: Date {
        Calendar.current.startOfDay(for: Date.now).addingTimeInterval(24 * 60 * 60)
    }
}
