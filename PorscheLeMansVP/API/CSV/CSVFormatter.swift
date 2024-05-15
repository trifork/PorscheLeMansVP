//
//  CSVFormatter.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 15/05/2024.
//

import Foundation

public struct CSVFormatter: Codable {
    var separator: String {
        ","
    }
    
    public func getValue<T>(_ keyPath: KeyPath<CSVDataItem, T?>, from channels: [String : Int], in columns: [String]) -> T? {
        if let channel = self.getChannel(keyPath), let columnNumber = channels[channel], let value = columns[safe: columnNumber] {
            if keyPath == \.timestamp {
                return parseTime(Int(value)!) as? T
            }
            return Double(value) as? T
        }
        return nil
    }
    
    public func parseTime(_ timeValue: Int) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(timeValue / 1000000))
    }
    
    public func getChannel<T>(_ keyPath: KeyPath<CSVDataItem, T?>) -> String? {
        let value = keyPath.propertyAsString
        return value
    }
}

extension KeyPath {
    var propertyAsString: String {
        "\(self)".components(separatedBy: ".").last ?? ""
    }
}
