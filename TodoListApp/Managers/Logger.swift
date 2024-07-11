//
//  Logger.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 11.07.2024.
//

import CocoaLumberjackSwift
import Foundation

final class Logger {
    
    enum Level {
        case debug, warning, error
    }
    
    func initLogger() {
        let consoleLogger = DDOSLogger.sharedInstance
        
        DDLog.add(consoleLogger)
    }
    
    static func log(_ message: DDLogMessageFormat, level: Level) {
        switch level {
        case .debug:
            infoDebug(message)
        case .warning:
            infoWarning(message)
        case .error:
            infoError(message)
        }
    }
    
    private static func infoDebug(_ message: DDLogMessageFormat) {
        DDLogInfo(message)
    }
    
    private static func infoError(_ message: DDLogMessageFormat) {
        DDLogError(message)
    }
    
    private static func infoWarning(_ message: DDLogMessageFormat) {
        DDLogWarn(message)
    }
    
    
}
