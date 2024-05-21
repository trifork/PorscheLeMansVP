//
//  DataClient+Dummy.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 13/05/2024.
//

import Foundation
import SwiftData

extension DataClient {
    
    @MainActor
    func fillLeaderboard() {
        let items = [
            RaceContestantItem(index: 1, carId: "6", position: 1, name: "T. Fekete", initials: "TFC", color: "FFFFFF", country: "dk", carType: "Porsche", time: 0, inPit: false, outOfTheRace: false),
            RaceContestantItem(index: 2, carId: "5", position: 2, name: "S. Zukanovic", initials: "SZU", color: "2941CD", country: "dk", carType: "Porsche", time: 0.1734, inPit: false, outOfTheRace: false),
            RaceContestantItem(index: 3, carId: "2", position: 3, name: "T. Miyazono", initials: "TMI", color: "00C0B2", country: "dm", carType: "Audi", time: 1.1735, inPit: false, outOfTheRace: false),
            RaceContestantItem(index: 4, carId: "3", position: 4, name: "J. Serrano", initials: "JSE", color: "C8211A", country: "at", carType: "Ferrari", time: 1.3737, inPit: false, outOfTheRace: false),
            RaceContestantItem(index: 5, carId: "4", position: 5, name: "L. Kringelbach", initials: "LKR", color: "FFFFFF", country: "dk", carType: "BMW", time: 1.7739, inPit: false, outOfTheRace: false),
            RaceContestantItem(index: 6, carId: "7", position: 6, name: "P. Blazsan", initials: "PBL", color: "E88A32", country: "au", carType: "Tesla", time: 2.1740, inPit: false, outOfTheRace: false),
            RaceContestantItem(index: 7, carId: "8", position: 7, name: "C. Lopez", initials: "CLO", color: "2941CD", country: "ec", carType: "Volkswagen", time: 2.4741, inPit: false, outOfTheRace: false),
            RaceContestantItem(index: 8, carId: "9", position: 8, name: "L. James", initials: "LJA", color: "EAEF4C", country: "ee", carType: "Citroen", time: 3.8743, inPit: false, outOfTheRace: false),
            RaceContestantItem(index: 9, carId: "10", position: 9, name: "R. Bonelli", initials: "RBO", color: "B29F6C", country: "jp", carType: "Skoda", time: 4.1744, inPit: false, outOfTheRace: false),
            RaceContestantItem(index: 10, carId: "11", position: 10, name: "V. Gallo", initials: "VGA", color: "4199DD", country: "es", carType: "Ford", time: 4.2745, inPit: false, outOfTheRace: false),
            RaceContestantItem(index: 11, carId: "12", position: 11, name: "G. Mangano", initials: "GMA", color: "881415", country: "ca", carType: "Fiat", time: 4.1748, inPit: false, outOfTheRace: false)
        ]
        
        for item in items {
            self.modelContainer.mainContext.insert(item)
        }
    }
    
    @MainActor
    func getLeaderboard() -> [RaceContestantItem] {
        let sortDescriptor = [SortDescriptor(\RaceContestantItem.time)]
        let descriptor = FetchDescriptor<RaceContestantItem>(sortBy: sortDescriptor)
        let items = try? modelContainer.mainContext.fetch(descriptor)

        return items ?? []
    }
    
    @MainActor
    func updateLeaderboard(for index: Int) {
        let predicate = #Predicate<RaceContestantItem> { $0.index == index }
        let descriptor = FetchDescriptor<RaceContestantItem>(predicate: predicate)
        if let item = try? modelContainer.mainContext.fetch(descriptor).first {
            
            item.time = Double.random(in: 0.1988...1.9871)
            
            modelContainer.mainContext.insert(item)
        }
    }
    
    @MainActor
    func writeTicker(productId: String, price: String) {
        let predicate = #Predicate<TickerItem> { $0.productId == productId }
        let descriptor = FetchDescriptor<TickerItem>(predicate: predicate)
        if let item = try? modelContainer.mainContext.fetch(descriptor).first {
            item.price = price
            modelContainer.mainContext.insert(item)
        } else {
            let item = TickerItem(productId: productId, price: price)
            modelContainer.mainContext.insert(item)
        }
    }
    
    @MainActor
    func getTickers() -> [TickerItem] {
        let sortDescriptor = [SortDescriptor(\TickerItem.productId)]
        let descriptor = FetchDescriptor<TickerItem>(sortBy: sortDescriptor)
        let items = try? modelContainer.mainContext.fetch(descriptor)

        return items ?? []
    }
    
}


extension DataClient {
    
    @MainActor
    func fillSpeedData() {
        let data: [Double] = [0]
        let item = RaceDataItem(channelId: "vCar", acqType: "", carId: "5bada085-67ef-43bb-bdcb-81ba93ee9fee", frequency: 2, data: data, nSamples: 1)
        
        self.modelContainer.mainContext.insert(item)
    }
    
    @MainActor
    func updateSpeedData() {
        let predicate = #Predicate<RaceDataItem> { $0.channelId == "vCar" }
        let descriptor = FetchDescriptor<RaceDataItem>(predicate: predicate)
        if let item = try? modelContainer.mainContext.fetch(descriptor).first {
            
            item.data.append(Double.random(in: 121...187))
            
            modelContainer.mainContext.insert(item)
        }
    }
    
    @MainActor
    func getCurrentSpeed() -> Double? {
        let predicate = #Predicate<RaceDataItem> { $0.channelId == "vCar" }
        let descriptor = FetchDescriptor<RaceDataItem>(predicate: predicate)
        if let item = try? modelContainer.mainContext.fetch(descriptor).first {
            return item.data.last
        }

        return nil
    }
    
    
    
}
