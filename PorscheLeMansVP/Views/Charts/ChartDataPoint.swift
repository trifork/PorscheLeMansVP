//
//  ChartDataPoint.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 16/05/2024.
//

import Foundation

public struct ChartDataPoint: Identifiable, Codable {
    public var id = UUID()
    public let x: Int
    public let y: Double
    
    public init(x: Int, y: Double) {
        self.x = x
        self.y = y
    }
}
