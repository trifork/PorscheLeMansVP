//
//  Date+String.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 15/05/2024.
//

import Foundation

extension Date {
    public func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
