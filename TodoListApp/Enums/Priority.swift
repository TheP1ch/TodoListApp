//
//  Priority.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 29.06.2024.
//

import Foundation

enum Priority: String, Comparable, CaseIterable, Codable {
    case low
    case basic
    case important

    var description: String {
        switch self {
        case .low:
            "неважная"
        case .basic:
            "обычная"
        case .important:
            "важная"
        }
    }

    static func < (lhs: Priority, rhs: Priority) -> Bool {
        switch (lhs, rhs) {
        case (.low, _):
            return true
        case (.basic, .important):
            return true
        case (.important, _):
            return false
        case (.basic, _):
            return false
        }
    }
}
