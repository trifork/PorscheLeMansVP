//
//  TickerItem.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 14/05/2024.
//

import Foundation
import SwiftData

@Model
final class TickerItem {
    @Attribute(.unique)
    var productId: String
    var price: String
    
    init(productId: String, price: String) {
        self.productId = productId
        self.price = price
    }
}
