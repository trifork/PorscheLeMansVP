//
//  Double+Round.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 16/05/2024.
//

import Foundation

extension Double {
    public func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

    public func rangePercentage(min: Double, max: Double) -> Double {
        return ((self - min) * 100) / (max - min)
    }
}

