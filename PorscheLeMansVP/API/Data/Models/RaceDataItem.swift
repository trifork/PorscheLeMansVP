//
//  RaceDataItem.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 13/05/2024.
//

import Foundation
import SwiftData

@Model
final class RaceDataItem {
    @Attribute(.unique)
    var channelId: String

    var acqType: String
    var carId: String
    var frequency: Int
    var data: [Double]
    var nSamples: Int
    
    init(channelId: String, acqType: String, carId: String, frequency: Int, data: [Double], nSamples: Int) {
        self.channelId = channelId
        self.acqType = acqType
        self.carId = carId
        self.frequency = frequency
        self.data = data
        self.nSamples = nSamples
    }
    
    /*
     carId : 5bada085-67ef-43bb-bdcb-81ba93ee9fee
     
     Channels :
    - aLatGPSFIARx (latitude gps position, °)
    - aLongGPSFIARx (longitude gps position, °)
    - aSteerWheel (steering wheel angle, °)
    - gear (current gear)
    - gLat (lateral g forces, m/s^2)
    - gLong (longitudinal g forces, m/s^2)
    - nmot (revs/min, rpm)
    - pBrakeF (brake force pressure, bar)
    - rThrottlePedal (throttle pedal, %)
    - vCar (car speed, km/h)
    */
}
