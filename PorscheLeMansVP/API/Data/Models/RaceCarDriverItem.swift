//
//  RaceCarDriverItem.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 16/05/2024.
//

import Foundation
import SwiftData

@Model
final class RaceCarDriverItem {
    @Attribute(.unique)
    var name: String
    
    var country: String
    
    init(name: String, country: String) {
        self.name = name
        self.country = country
    }
}
