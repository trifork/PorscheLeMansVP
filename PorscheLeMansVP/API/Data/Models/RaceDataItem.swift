//
//  RaceDataItem.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 13/05/2024.
//

import Foundation
import SwiftData

@Model
final class RaceDataItem {
    @Attribute(.unique)
    var index: Int
    
    var date: Date?
    
    init(index: Int, date: Date? = nil) {
        self.index = index
        self.date = date
    }
}
