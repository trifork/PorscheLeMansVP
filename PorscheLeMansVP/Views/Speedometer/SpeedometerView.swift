//
//  SpeedometerView.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 16/05/2024.
//

import SwiftUI

public struct SpeedometerView: View {
    @State private var indexTimer = Timer.publish(every: 0.26, on: .main, in: .common).autoconnect()
    @State private var index: Int = 0
    
    private let ticksModel: TicksModel = TicksModel(inset: 0, smallTickHeight: 16, bigTickHeight: 32, totalTicks: 46, tickInterval: 5)
    private let accelerationModel: TicksModel = TicksModel(inset: 0, smallTickHeight: 32, bigTickHeight: 32, totalTicks: 92, tickInterval: 10)
    private let textModel: TicksTextModel = TicksTextModel(ticks: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"], inset: -40, isGauge: true)
    
    @State private var speed: Double?
    @State private var rpm: Double?
    
    public var body: some View {
        VStack {
            ZStack() {
                ZStack() {
                    SpeedometerTicksView(model: ticksModel) // Grey ticks
                
                    AccelerationMaskView(model: accelerationModel).mask { // Red ticks
                        AccelerationView(currentRpm: rpm ?? 0.0)
                    }
                }
                
                VStack() {
                    TickTextView(model: self.textModel) // Clock counter 0 - 9
                        .foregroundColor(.white)
                        .font(.title)
                        .scaledToFit()
                        .minimumScaleFactor(0.05)
                }
                
                SpeedAndGearCenterView // Showing (couting) speed km/h
            }
        }
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
        
        speed = item?.vCar
        rpm = (item?.nmot ?? 0.0) / 10000
    }
}


extension SpeedometerView {
    private var SpeedAndGearCenterView: some View {
        VStack {
            Spacer()
            
            VStack() {
                Spacer()
                
                VStack {
                    Text("\(Int(speed ?? 0))")
                        .font(Asset.Fonts.porscheBold(size: 52))
                        .foregroundColor(.white)
                        
                    Text("km/h")
                        .font(Asset.Fonts.porscheBold(size: 28))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text("x 1000 r/min")
                    .font(Asset.Fonts.porscheRegular(size: 16))
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
            }
        }
        
    }
}
