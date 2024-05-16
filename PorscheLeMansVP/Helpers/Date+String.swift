//
//  Date+String.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 15/05/2024.
//

import Foundation

extension Date {
    
    public var fullTimeMS: String { self.toString(format: "HH:mm:ss.SSSS") }
    public var fullTime: String { self.toString(format: "HH:mm:ss") }
    
    public func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
