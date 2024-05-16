//
//  LineChartWrapperView.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 16/05/2024.
//

import Foundation
import SwiftUI
import Charts

public struct LineChartWrapperView: View {
    @State private var indexTimer = Timer.publish(every: 0.26, on: .main, in: .common).autoconnect()
    @State private var index: Int = 0
    
    @State private var speed: [ChartDataPoint] = []
    @State private var rpm: [ChartDataPoint] = []
    @State private var throttle: [ChartDataPoint] = []
    @State private var brake: [ChartDataPoint] = []
    @State private var gforceX: [ChartDataPoint] = []
    @State private var gforceY: [ChartDataPoint] = []
    
    private let maxCnt: Int = 100
    
    public var body: some View {
        VStack(spacing: 16) {
            
            LineDataChartView(title: "Speed (km/h)", items: [speed], colors: [Color.blue], legends: ["Speed"], index: index, minYScale: 0, maxYScale: 400, maxCnt: maxCnt)
            
            LineDataChartView(title: "Rpm", items: [rpm], colors: [Color.yellow], legends: ["Rpm"], index: index, minYScale: 0, maxYScale: 10, maxCnt: maxCnt)
            
            LineDataChartView(title: "Throttle (%) / Brake (bar)", items: [throttle, brake], colors: [Color.green, Color.orange], legends: ["Throttle", "Brake"], index: index, minYScale: 0, maxYScale: 100, maxCnt: maxCnt)
            
            LineDataChartView(title: "GForce X/Y", items: [gforceX, gforceY], colors: [Color.red, Color.white], legends: ["GForce X", "GForce Y"], index: index, minYScale: -30, maxYScale: +30, maxCnt: maxCnt)
                
        }
        .onReceive(indexTimer) { _ in
            index += 1
            
            if let items = DataClient.shared.getCSVItem(before: index, limit: maxCnt) {
                speed = items.enumerated().map { (idx, item) in
                    return ChartDataPoint(x: idx, y: item.vCar ?? 0.0)
                }
                
                rpm = items.enumerated().map { (idx, item) in
                    return ChartDataPoint(x: idx, y: (item.nmot ?? 0.0) / 1000)
                }
                
                throttle = items.enumerated().map { (idx, item) in
                    return ChartDataPoint(x: idx, y: item.rThrottlePedal ?? 0.0)
                }
                
                brake = items.enumerated().map { (idx, item) in
                    return ChartDataPoint(x: idx, y: item.pBrakeF ?? 0.0)
                }
                
                gforceX = items.enumerated().map { (idx, item) in
                    return ChartDataPoint(x: idx, y: item.gLat ?? 0.0)
                }
                
                gforceY = items.enumerated().map { (idx, item) in
                    return ChartDataPoint(x: idx, y: item.gLong ?? 0.0)
                }
            }
        }
    }
    
}
