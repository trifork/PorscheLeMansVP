//
//  CSVDataItem.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 15/05/2024.
//

import Foundation
import SwiftData

@Model
public final class CSVDataItem {
    @Attribute(.unique)
    var index: Int
    
    var timestamp: Date?
    var rClutchPaddle: Double?
    var pBrakeF: Double?
    var vCar: Double?
    var gLong: Double?
    var xRideHeightR: Double?
    var t_eng_oil: Double?
    var trq_eng: Double?
    var gLat: Double?
    var nmot: Double?
    var lvl_water: Double?
    var aLongGPSFIARx: Double?
    var xRideHeightFL: Double?
    var xRideHeightFR: Double?
    var aSteerWheel: Double?
    var m_fuel: Double?
    var rThrottlePedal: Double?
    var SOC: Double?
    var lvl_eng_oil: Double?
    var t_eng_water_in: Double?
    var aLatGPSFIARx: Double?
    var t_eng_water_out: Double?
    var t_gbx: Double?
    var gear: Double?
    
    /*
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
 
    init(index: Int, timestamp: Date? = nil, rClutchPaddle: Double? = nil, pBrakeF: Double? = nil, vCar: Double? = nil, gLong: Double? = nil, xRideHeightR: Double? = nil, t_eng_oil: Double? = nil, trq_eng: Double? = nil, gLat: Double? = nil, nmot: Double? = nil, lvl_water: Double? = nil, aLongGPSFIARx: Double? = nil, xRideHeightFL: Double? = nil, xRideHeightFR: Double? = nil, aSteerWheel: Double? = nil, m_fuel: Double? = nil, rThrottlePedal: Double? = nil, SOC: Double? = nil, lvl_eng_oil: Double? = nil, t_eng_water_in: Double? = nil, aLatGPSFIARx: Double? = nil, t_eng_water_out: Double? = nil, t_gbx: Double? = nil, gear: Double? = nil) {
        self.index = index
        self.timestamp = timestamp
        self.rClutchPaddle = rClutchPaddle
        self.pBrakeF = pBrakeF
        self.vCar = vCar
        self.gLong = gLong
        self.xRideHeightR = xRideHeightR
        self.t_eng_oil = t_eng_oil
        self.trq_eng = trq_eng
        self.gLat = gLat
        self.nmot = nmot
        self.lvl_water = lvl_water
        self.aLongGPSFIARx = aLongGPSFIARx
        self.xRideHeightFL = xRideHeightFL
        self.xRideHeightFR = xRideHeightFR
        self.aSteerWheel = aSteerWheel
        self.m_fuel = m_fuel
        self.rThrottlePedal = rThrottlePedal
        self.SOC = SOC
        self.lvl_eng_oil = lvl_eng_oil
        self.t_eng_water_in = t_eng_water_in
        self.aLatGPSFIARx = aLatGPSFIARx
        self.t_eng_water_out = t_eng_water_out
        self.t_gbx = t_gbx
        self.gear = gear
    }
    
}
