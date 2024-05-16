//
//  CarResponse.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 15/05/2024.
//

import Foundation

public struct CarResponse: Codable, Hashable {
    public let carId: String
    public let team: String
    public let car: String
    public let type: String
    public let drivers: [DriverResponse]
    public let stream: String?
}

public struct DriverResponse: Codable, Hashable {
    public let name: String
    public let country: String
}
