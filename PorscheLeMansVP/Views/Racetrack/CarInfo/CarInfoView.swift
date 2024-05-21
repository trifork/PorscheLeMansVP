//
//  CarInfoView.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 21/05/2024.
//

import SwiftUI

public struct CarInfoView: View {
    @State private var car: RaceCarItem?
    private var carId: String?
    private var selectedCarId: String?
    
    public init(carId: String, dataChanged: Bool, selectedCarId: String? = nil) {
        self.carId = carId
        self.selectedCarId = selectedCarId
    }
    
    public var body: some View {
        VStack {
            if let car = car {
                let isSelected = car.carId == selectedCarId
                
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundColor(isSelected ? .black : .white)
                        .opacity(isSelected ? 1.0 : 0.0)
                    
                    Text(car.team)
                        .foregroundColor(isSelected ? .black : .white)
                    
                    //Spacer()
                    
                    Text("274 km/h")
                        .foregroundColor(isSelected ? .black : .white)
                    
                    Text("+4.125")
                        .foregroundColor(isSelected ? .black : .white)
                }
                .padding(20)
                //.frame(width: 250)
                .background(isSelected ? Color.glassBlue : .black.opacity(0.5))
                .opacity(isSelected ? 1.0 : 0.5)
            }
        }
        .onAppear() {
            if let carId = carId {
                self.car = DataClient.shared.getCar(by: carId)
            }
        }
    }
    
}
