//
//  Color+hex.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 15/05/2024.
//

import SwiftUI

extension Color {
    init(hex: String, alpha: Double = 1.0) {
        var hexString = hex
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            hexString = String(hex[start...])
        }
        
        if hexString.count == 6 {
            hexString = hexString + "ff"
        }
        
        let scanner = Scanner(string: hexString)
        var hexNumber: UInt64 = 0
        guard scanner.scanHexInt64(&hexNumber) else {
            self.init(.clear)
            return
        }
        
        self.init(
            .sRGB,
            red: Double((hexNumber >> 16) & 0xff) / 255,
            green: Double((hexNumber >> 08) & 0xff) / 255,
            blue: Double((hexNumber >> 00) & 0xff) / 255,
            opacity: alpha
        )        
    }
}
