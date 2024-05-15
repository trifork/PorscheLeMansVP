//
//  TempDataView.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 15/05/2024.
//

import SwiftUI

struct TempDataView: View {
    
    @State private var indexTimer = Timer.publish(every: 0.26, on: .main, in: .common).autoconnect()
    @State private var index: Int = 0
    
    @State private var firstTime: Date?
    @State private var currentTime: Date?
    @State private var duration: Int?
    
    @State private var currentSpeed: Double?
    @State private var currentRpm: Double?
    @State private var currentGear: Double?
    @State private var currentGForceX: Double?
    @State private var currentGForceY: Double?
    @State private var currentBrake: Double?
    @State private var currentThrottle: Double?
    @State private var currentFuel: Double?
    
    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                //TitleView(title: "Time :", value: "\(currentTime?.toString(format: "HH:mm:ss") ?? "0")")
                TitleView(title: "Duration :", value: "\(-(duration ?? 0)) sec.")
                TitleView(title: "Speed :", value: "\(Int(currentSpeed ?? 0.0)) km/h")
                TitleView(title: "RPM :", value: "\(String(format: "%.0f", currentRpm ?? 0.0)) rpm")
                TitleView(title: "Gear :", value: "\(String(format: "%.0f", currentGear ?? 0.0))")
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 0)  {
                TitleView(title: "GFrce X/Y :", value: "\(String(format: "%.1f", currentGForceX ?? 0.0)) / \(String(format: "%.1f", currentGForceY ?? 0.0))")
                TitleView(title: "Brake :", value: "\(String(format: "%.1f", currentBrake ?? 0.0))")
                TitleView(title: "Throttle :", value: "\(String(format: "%.1f", currentThrottle ?? 0.0))")
                TitleView(title: "Fuel :", value: "\(String(format: "%.1f", currentFuel ?? 0.0))")
            }
            
        }
        .onAppear() {
            firstTime = DataClient.shared.getCSVItem(for: 0)?.timestamp
        }
        .onReceive(indexTimer) { _ in
            
            index += 1
            let item = DataClient.shared.getCSVItem(for: index)
            
            duration = item?.timestamp?.distance(to: firstTime ?? Date()).seconds
            
            currentTime = item?.timestamp
            currentSpeed = item?.vCar
            currentRpm = item?.nmot
            currentGear = item?.gear
            currentGForceX = item?.gLat
            currentGForceY = item?.gLong
            currentBrake = item?.pBrakeF
            currentThrottle = item?.rThrottlePedal
            currentFuel = item?.m_fuel
        }
        .padding(20)
    }
    
}

public struct TitleView: View {
    let title: String
    let value: String
    
    public var body: some View {
        HStack {
            Text("\(title)")
                .font(Asset.Fonts.porscheRegular(size: 36))
            
            Text("\(value)")
                .font(Asset.Fonts.porscheBold(size: 40))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}
