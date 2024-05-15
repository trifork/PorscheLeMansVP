//
//  TimeInterval+Calc.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 15/05/2024.
//

import Foundation

extension TimeInterval {
    
    var seconds: Int {
        return Int(self.rounded())
    }
    
    var milliseconds: Int {
        return Int(self * 1_000)
    }
}
