//
//  Priority.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 29.06.2024.
//

import Foundation

enum Priority: String, Comparable, CaseIterable {
    case low = "неважная"
    case normal = "обычная"
    case important = "важная"

    static func < (lhs: Priority, rhs: Priority) -> Bool {
        switch (lhs, rhs) {
        case (.low, _):
            return true
        case (.normal, .important):
            return true
        case (.important, _):
            return false
        case (.normal, _):
            return false
        }
    }
}
