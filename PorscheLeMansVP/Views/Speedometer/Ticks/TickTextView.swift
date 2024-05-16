//
//  TickTextView.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 16/05/2024.
//

import SwiftUI

struct TickTextView: View {
    let model: TicksTextModel
    
    private struct IdentifiableTicks: Identifiable {
        var id: Int
        var tick: String
    }
    
    private var dataSource: [IdentifiableTicks] {
        model.ticks.enumerated().map { IdentifiableTicks(id: $0, tick: $1) }
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ForEach(self.dataSource) {
                    Text("\($0.tick)")
                        .position(
                            self.position(for: $0.id, in: proxy.frame(in: .local))
                        ).foregroundStyle(textColor(for: $0.id))
                }
            }
        }
    }
    
    private func textColor(for index: Int) -> Color {
        if (model.isGauge) {
            return index < 8 ? .white : .red
        }
        return .white
    }
    
    private func position(for index: Int, in rect: CGRect) -> CGPoint {
        let rect = rect.insetBy(dx: model.inset, dy: model.inset)
        let angle = angle(for: index)
        let radius = min(rect.width, rect.height)/2
        return CGPoint(x: rect.midX + radius * cos(angle), y: rect.midY + radius * sin(angle))
    }
    
    private func angle(for index: Int) -> Double {
        var angle = 0.0
        
        if (model.isGauge) {
            angle = 1.89 + (2 * .pi / CGFloat(model.ticks.count)) * CGFloat(index)
        } else {
            angle = ((2 * .pi) / CGFloat(model.ticks.count) * CGFloat(index)) - .pi/2
        }
        return angle
    }
}

