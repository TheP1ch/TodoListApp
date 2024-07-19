//
//  LogFormatter.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 11.07.2024.
//
// from https://blog.canopas.com/ios-how-to-setup-logging-correctly-with-cocoalumberjack-37836ec821b0#2c92

import CocoaLumberjack
import Foundation

final class LogFormatter: NSObject, DDLogFormatter {
    private let dateFormatter: DateFormatter

    override init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        super.init()
    }

    func format(message logMessage: DDLogMessage) -> String? {
        let timestamp = dateFormatter.string(from: logMessage.timestamp)
        let logText = logMessage.message

        return "\(timestamp) - \(logText)"
    }
}
