//
//  SpeedometerTicksView.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 16/05/2024.
//

import SwiftUI

struct SpeedometerTicksView: View {
    let model: TicksModel
    
    var body: some View {
        ForEach(0..<model.totalTicks, id: \.self) { index in
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
            .foregroundColor(color(at: index))
        }
    }
    
    func color(at index: Int) -> Color {
        if (index % 5 == 0 || index > (model.totalTicks - 6)) {
            return Color.red
        }
        return Color.gray
    }
}
