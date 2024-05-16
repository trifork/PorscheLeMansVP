//
//  ViewModifiers.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 15/05/2024.
//

import SwiftUI

struct DarkGlasBackgroundEffect: ViewModifier {
    var opacity: Double = 0.50
    
    func body(content: Content) -> some View {
        content
            .background(Color.black.opacity(opacity))
            .glassBackgroundEffect()
    }
}
