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
    var name: String
    var initials: String
    var colorCode: String // hex
    var country: String
    var carId: String
    var time: Double
    var inPit: Bool
    var outOfTheRace: Bool
    
    init(index: Int, position: Int, name: String, initials: String, colorCode: String, country: String, carId: String, time: Double, inPit: Bool, outOfTheRace: Bool) {
        self.index = index
        self.position = position
        self.name = name
        self.initials = initials
        self.colorCode = colorCode
        self.country = country
        self.carId = carId
        self.time = time
        self.inPit = inPit
        self.outOfTheRace = outOfTheRace
    }
}
