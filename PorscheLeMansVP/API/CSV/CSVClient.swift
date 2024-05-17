//
//  CSVClient.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 15/05/2024.
//

import Foundation

public class CSVClient {
    public static let shared = CSVClient()
    
    // File = lap_7f7c3f41-0e9b-46a4-ac91-8df0908e48c7
    @MainActor
    public func prefill(_ success: @escaping () -> Void, failure: @escaping (_ message: String) -> Void) async {
        
        let fileName = "lap_7f7c3f41-0e9b-46a4-ac91-8df0908e48c7"

        log(message: "CSV: parcing \(fileName)", level: .info)
        
        let formatter = CSVFormatter()
        
        do {
            
            guard let dataPath = Bundle.main.url(forResource: fileName, withExtension: "csv") else {
                failure("Failure: No CSV file found")
                return
            }
            
            let handle = try FileHandle(forReadingFrom: dataPath)
            defer { try? handle.close() }
            
            var index: Int = 0
            var firstLineHandled = false
            var channels = [String: Int]()
            for try await line in handle.bytes.lines {
                if firstLineHandled == false {
                    // Build column names for first line
                    let columnNames = line.components(separatedBy: formatter.separator)
                    columnNames.enumerated().forEach { index, name in
                        channels[String(name)] = index
                    }
                    firstLineHandled = true
                } else {
                    // Parse column content line by line
                    let columns = line.components(separatedBy: formatter.separator)
                    
                    let timestamp: Date? = formatter.getValue(\.timestamp, from: channels, in: columns)
                    if let timestamp = timestamp {
                        
                        let rClutchPaddle: Double? = formatter.getValue(\.rClutchPaddle, from: channels, in: columns)
                        let pBrakeF: Double? = formatter.getValue(\.pBrakeF, from: channels, in: columns)
                        let vCar: Double? = formatter.getValue(\.vCar, from: channels, in: columns)
                        let gLong: Double? = formatter.getValue(\.gLong, from: channels, in: columns)
                        let xRideHeightR: Double? = formatter.getValue(\.xRideHeightR, from: channels, in: columns)
                        let t_eng_oil: Double? = formatter.getValue(\.t_eng_oil, from: channels, in: columns)
                        let trq_eng: Double? = formatter.getValue(\.trq_eng, from: channels, in: columns)
                        let gLat: Double? = formatter.getValue(\.gLat, from: channels, in: columns)
                        let nmot: Double? = formatter.getValue(\.nmot, from: channels, in: columns)
                        let lvl_water: Double? = formatter.getValue(\.lvl_water, from: channels, in: columns)
                        let aLongGPSFIARx: Double? = formatter.getValue(\.aLongGPSFIARx, from: channels, in: columns)
                        let xRideHeightFL: Double? = formatter.getValue(\.xRideHeightFL, from: channels, in: columns)
                        let xRideHeightFR: Double? = formatter.getValue(\.xRideHeightFR, from: channels, in: columns)
                        let aSteerWheel: Double? = formatter.getValue(\.aSteerWheel, from: channels, in: columns)
                        let m_fuel: Double? = formatter.getValue(\.m_fuel, from: channels, in: columns)
                        let rThrottlePedal: Double? = formatter.getValue(\.rThrottlePedal, from: channels, in: columns)
                        let SOC: Double? = formatter.getValue(\.SOC, from: channels, in: columns)
                        let lvl_eng_oil: Double? = formatter.getValue(\.lvl_eng_oil, from: channels, in: columns)
                        let t_eng_water_in: Double? = formatter.getValue(\.t_eng_water_in, from: channels, in: columns)
                        let aLatGPSFIARx: Double? = formatter.getValue(\.aLatGPSFIARx, from: channels, in: columns)
                        let t_eng_water_out: Double? = formatter.getValue(\.t_eng_water_out, from: channels, in: columns)
                        let t_gbx: Double? = formatter.getValue(\.t_gbx, from: channels, in: columns)
                        let gear: Double? = formatter.getValue(\.gear, from: channels, in: columns)
                        
                        let dataItem = CSVDataItem(index: index, timestamp: timestamp, rClutchPaddle: rClutchPaddle, pBrakeF: pBrakeF, vCar: vCar, gLong: gLong, xRideHeightR: xRideHeightR, t_eng_oil: t_eng_oil, trq_eng: trq_eng, gLat: gLat, nmot: nmot, lvl_water: lvl_water, aLongGPSFIARx: aLongGPSFIARx, xRideHeightFL: xRideHeightFL, xRideHeightFR: xRideHeightFR, aSteerWheel: aSteerWheel, m_fuel: m_fuel, rThrottlePedal: rThrottlePedal, SOC: SOC, lvl_eng_oil: lvl_eng_oil, t_eng_water_in: t_eng_water_in, aLatGPSFIARx: aLatGPSFIARx, t_eng_water_out: t_eng_water_out, t_gbx: t_gbx, gear: gear)
                        
                        DataClient.shared.insertFromCSV(dataItem)
                        
                        index += 1
                    }
                }
            }
            
            success()
        } catch {
            failure("Failure: Cant parse CSV")
        }
    }
}
