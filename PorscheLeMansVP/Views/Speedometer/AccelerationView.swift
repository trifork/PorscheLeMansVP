//
//  AccelerationView.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 16/05/2024.
//

import SwiftUI

struct AccelerationView: View {
    private var currentRpm: Double
    
    init(currentRpm: Double) {
        self.currentRpm = currentRpm.round(to: 2)
    }
    
    var body: some View {
        Circle()
            .trim(from: 0.0, to: currentRpm)
            .stroke(style: StrokeStyle(lineWidth: 32.0, lineCap: .butt, lineJoin: .miter))
            .foregroundColor(Color.red)
            .rotationEffect(.degrees(108))
            .padding()
            .animation(.easeInOut, value: currentRpm)
    }
}

