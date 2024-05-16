//
//  TicksShape.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 16/05/2024.
//

import SwiftUI

struct TicksShape: Shape {
    let inset: CGFloat
    let smallTickHeight: CGFloat
    let bigTickHeight: CGFloat
    let totalTicks: Int
    let tickInterval: Int
    let isGauge: Bool
    let isHalfSized: Bool
    let index: Int
    
    func path(in rect: CGRect) -> Path {
        let rect = rect.insetBy(dx: inset, dy: inset)
        let condition = index % tickInterval == 0
        let height: CGFloat = condition ? bigTickHeight : smallTickHeight
        
        var path = Path()
        path.move(to: topPosition(for: angle(for: index), in: rect))
        path.addLine(to: bottomPosition(for: angle(for: index), in: rect, height: height))
        
        return path
    }
    
    private func angle(for index: Int) -> CGFloat {
        let value = isGauge ? 1.837 : 2.0
        let degrees = isGauge ? 1.89 : 0.0
        let piValue = isHalfSized ? value * (.pi / 2) : value * .pi
        return degrees + (piValue / CGFloat(totalTicks)) * CGFloat(index)
    }
    
    private func topPosition(for angle: CGFloat, in rect: CGRect) -> CGPoint {
        let radius = min(rect.height, rect.width)/2
        let xPosition = rect.midX + (radius * cos(angle))
        let yPosition = rect.midY + (radius * sin(angle))
        return CGPoint(x: xPosition, y: yPosition)
    }
    
    private func bottomPosition(for angle: CGFloat, in rect: CGRect, height: CGFloat) -> CGPoint {
        let radius = min(rect.height, rect.width)/2
        let xPosition = rect.midX + ((radius - height) * cos(angle))
        let yPosition = rect.midY + ((radius - height) * sin(angle))
        return CGPoint(x: xPosition, y: yPosition)
    }
}

