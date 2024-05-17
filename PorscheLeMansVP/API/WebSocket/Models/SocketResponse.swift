//
//  SocketResponse.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 17/05/2024.
//

import Foundation

public struct SocketResponse: Codable {
    let timestamp: Int
    let cars: [String: SocketCar]
}

struct SocketCar: Codable {
    let rgps: SocketGPS
    let rpm: Int?
    let throttle: Double?
    let brake: Int?
    let speed: Int?
    let gforce: SocketGForce?
}

struct SocketGPS: Codable {
    let lat: Double
    let long: Double
}

struct SocketGForce: Codable {
    let x: Double
    let y: Double
}
