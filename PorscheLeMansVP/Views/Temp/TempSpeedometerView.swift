//
//  TempSpeedometerView.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 14/05/2024.
//

import SwiftUI

struct TempSpeedometerView: View {
    
    @State private var indexTimer = Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()
    @State private var index: Int = 0
    
    @State private var speed: Double?

    private let lineWidth = 8.0
    
    private var speedAngle: Angle {
        let zeroPoint = -90.0 // 0
        let maxPoint = 90.0 // 260
        let currentSpeed = speed ?? 0.0
        let maxSpeed = 360.0
        
        let procent = (currentSpeed / maxSpeed) * 100
        let angle = (procent * 180) / 100
        var result = zeroPoint + angle
        if result > maxPoint {
            result = maxPoint
        }
        return Angle.degrees(result)
    }

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            ZStack {
                GeometryReader { geometry in
                    Circle()
                        .trim(from: 0.0, to: 0.50)
                        .stroke(Color.white, lineWidth: lineWidth)
                        .rotationEffect(.degrees(-180))
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                        .overlay (
                            Circle()
                                .trim(from: 0.0, to: 0.50)
                                .stroke(Color.red, lineWidth: lineWidth)
                                .rotationEffect(.degrees(-180))
                                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                        )
                }
                
                Text("\(Int(speed ?? 0)) km/h")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white.opacity(0.96))
                    .offset(y: 30)
                

                NeedleShape(inset: 10, angle: speedAngle)
                    .stroke(lineWidth: 6.0)
                    .foregroundColor(.white)
                    .animation(.linear(duration: 0.9), value: speedAngle.degrees)
                
            }
        }
        .onReceive(indexTimer) { _ in
            index += 1
            speed = DataClient.shared.getCSVItem(for: index)?.vCar
        }
        .onAppear() {
            speed = DataClient.shared.getCSVItem(for: index)?.vCar
        }
    }
}


struct NeedleShape: Shape {
    let inset: CGFloat
    let angle: Angle
    
    func path(in rect: CGRect) -> Path {
        let rect = rect.insetBy(dx: inset, dy: inset)
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.midY))
        path.addLine(to: position(for: CGFloat(angle.radians), in: rect))
        return path
    }
    
    private func position(for angle: CGFloat, in rect: CGRect) -> CGPoint {
        let angle = angle - (.pi/2)
        let radius = min(rect.width, rect.height)/2
        let xPosition = rect.midX + (radius * cos(angle))
        let yPosition = rect.midY + (radius * sin(angle))
        return CGPoint(x: xPosition, y: yPosition)
    }
}
