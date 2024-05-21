//
//  RaceContestantItem.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 13/05/2024.
//

import Foundation
import SwiftData

@Model
final class RaceContestantItem {
    @Attribute(.unique)
    var index: Int
    
    var position: Int
    var carId: String
    var name: String
    var initials: String
    var color: String // hex
    var country: String
    var carType: String
    var time: Double
    var inPit: Bool
    var outOfTheRace: Bool
    
    init(index: Int, carId: String, position: Int, name: String, initials: String, color: String, country: String, carType: String, time: Double, inPit: Bool, outOfTheRace: Bool) {
        self.index = index
        self.carId = carId
        self.position = position
        self.name = name
        self.initials = initials
        self.color = color
        self.country = country
        self.carType = carType
        self.time = time
        self.inPit = inPit
        self.outOfTheRace = outOfTheRace
    }
}
