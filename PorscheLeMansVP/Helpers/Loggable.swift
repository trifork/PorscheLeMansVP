//
//  Loggable.swift
//  SuperYachtVP
//
//  Created by Thomas Fekete Christensen on 27/03/2024.
//

import Foundation

internal enum LogLevel {
    case error
    case info
    case debug
    case warning
    case custom(String)
    
    internal var description: String {
        switch self {
        case .error: return "🛑"
        case .info: return "💡"
        case .debug: return "🤪"
        case .warning: return "⚠️"
        case .custom(let symbol): return symbol
        }
    }
}

internal func log(message: String, level: LogLevel) {
    #if DEBUG
    print("\(level.description) \(message)")
    #endif
}

