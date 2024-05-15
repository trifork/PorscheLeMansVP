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
        var items: [RaceContestantItem] = []
        items.append(RaceContestantItem(index: 1, position: 1, name: "Rico Laursen", initials: "RLA", colorCode: "", country: "DK", carId: "a1", time: 0, inPit: false, outOfTheRace: false))
        items.append(RaceContestantItem(index: 2, position: 2, name: "Jim Andersen", initials: "JAN", colorCode: "", country: "UK", carId: "b2", time: 0.645, inPit: false, outOfTheRace: false))
        items.append(RaceContestantItem(index: 3, position: 3, name: "Marius Folloingrish", initials: "MAF", colorCode: "", country: "SP", carId: "c3", time: 1.298, inPit: false, outOfTheRace: false))
        
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
