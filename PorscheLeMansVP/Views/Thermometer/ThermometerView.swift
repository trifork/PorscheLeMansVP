//
//  ThermometerView.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 16/05/2024.
//

import SwiftUI

public struct ThermometerView: View {
    public let type: ThermometerType
    public let alignment: ThermometerTextAlignment
    public let indicator: String
    
    @State private var indexTimer = Timer.publish(every: 0.26, on: .main, in: .common).autoconnect()
    @State private var index: Int = 0
    
    @State private var percent: Double = 0.0
    
    public var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top, spacing: 12) {
                    if alignment == .left {
                        ThermometerTextView(alignment: alignment)
                    } else {
                        Color(.clear).frame(width: 27)
                    }
                
                VStack() {
                    ForEach((0..<25).reversed(), id: \.self) { index in
                        
                        let isActive = Double(index * 4) < percent ? true : false // calc percent
                        
                        RoundedRectangle(cornerRadius: 4)
                            .frame(height: 4, alignment: .center)
                            .frame(width: isActive ? 32 : 8, alignment: .center)
                            .foregroundColor(isActive ? Color.red : Color.gray)
                    }
                }
                .frame(width: 32, alignment: .center)
                .animation(.smooth, value: percent)
                
                ZStack {
                    if alignment == .right {
                        ThermometerTextView(alignment: alignment)
                    } else {
                        Color(.clear).frame(width: 27)
                    }
                }
            }
            Text(indicator).font(.system(size: 17, weight: .regular))
        }
        .fixedSize(horizontal: false, vertical: true)
        .onReceive(indexTimer) { _ in
            index += 1
            calcValues()
        }
        .onAppear() {
            calcValues()
        }
    }
    
    @MainActor private func calcValues() {
        let item = DataClient.shared.getCSVItem(for: index)
        
        switch type {
        case .brake:
            percent = item?.pBrakeF ?? 0.0
        case .throttle:
            percent = item?.rThrottlePedal ?? 0.0
        }
    }
}

