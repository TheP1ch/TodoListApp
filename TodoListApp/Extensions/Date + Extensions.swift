//
//  Date + Extensions.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 30.06.2024.
//

import Foundation

extension Date {
    static var tommorow: Date {
        Calendar.current.startOfDay(for: Date.now).addingTimeInterval(24 * 60 * 60)
    }
}
