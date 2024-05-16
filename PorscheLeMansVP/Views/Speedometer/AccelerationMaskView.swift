//
//  AccelerationMaskView.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 16/05/2024.
//

import SwiftUI

struct AccelerationMaskView: View {
    let model: TicksModel
    
    var body: some View {
        ForEach(0..<model.totalTicks-1, id: \.self) { index in
            TicksShape(
                inset: model.inset,
                smallTickHeight: model.smallTickHeight,
                bigTickHeight: model.bigTickHeight,
                totalTicks: model.totalTicks,
                tickInterval: model.tickInterval,
                isGauge: true,
                isHalfSized: false,
                index: index
            )
            .stroke(lineWidth: 4)
            .foregroundColor(Color.red)
        }
    }
}

