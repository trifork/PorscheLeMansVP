//
//  LineDataChartView.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 16/05/2024.
//

import Foundation
import SwiftUI
import Charts

public struct LineDataChartView: View {

    private var chartTitle: String = ""
    private var items: [[ChartDataPoint]] = []
    private var colors: [Color] = []
    private var legends: [String]?
    private var showLegends: Visibility = .hidden
    private var currentIndex: Int = 0
    private var minYScale: Int = 0
    private var maxYScale: Int = 0
    private var maxCnt: Int = 0
    
    public init(title: String, items: [[ChartDataPoint]], colors: [Color], legends: [String]? = nil, index: Int, minYScale: Int, maxYScale: Int, maxCnt: Int) {
        self.chartTitle = title
        self.items = items
        self.colors = colors
        self.legends = legends
        self.showLegends = (legends != nil) ? .visible : .hidden
        self.minYScale = minYScale
        self.maxYScale = maxYScale
        self.maxCnt = maxCnt
        self.currentIndex = index
    }
    
    public var body: some View {
        
        HStack() {
            GroupBox(chartTitle) {
                Spacer().frame(height: 22)
                
                Chart {
                    
                    ForEach(Array(items.enumerated()), id: \.offset) { index, dataPoints in
                        ForEach(dataPoints) {
                            LineMark(
                                x: .value("Count", $0.x),
                                y: .value("Points", $0.y)
                            )
                            .interpolationMethod(.catmullRom)
                            .foregroundStyle(colors[index])
                            .foregroundStyle(by: .value("GroupedData", legends?[index] ?? "\(index)"))
                            .lineStyle(StrokeStyle(lineWidth: 5))
                        }
                    }
                }
                .animation(.linear(duration: 1.0), value: currentIndex)
                .chartForegroundStyleScale(range: colors)
                .chartLegend(showLegends)
                .chartYAxis() {
                    AxisMarks(position: .trailing)
                }
                .chartXScale(domain: [0, maxCnt])
                .chartYScale(domain: [minYScale, maxYScale])
            }
            .backgroundStyle(.clear)
            .padding(.vertical, 10)
            .padding(.horizontal, 10)
        }
        .cornerRadius(22)
    }
}
