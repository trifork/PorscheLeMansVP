//
//  RaceCarItem.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 16/05/2024.
//

import Foundation
import SwiftData

@Model
final class RaceCarItem {
    @Attribute(.unique)
    var carId: String
    
    var team: String
    var car: String
    var type: String
    //@Relationship(inverse: \RaceCarDriverItem) var drivers: [RaceCarDriverItem]
    var drivers: [RaceCarDriverItem]
    var stream: String?
    
    init(carId: String, team: String, car: String, type: String, drivers: [RaceCarDriverItem], stream: String? = nil) {
        self.carId = carId
        self.team = team
        self.car = car
        self.type = type
        self.drivers = drivers
        self.stream = stream
    }
}
