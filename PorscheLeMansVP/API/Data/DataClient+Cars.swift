//
//  DataClient+Cars.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 16/05/2024.
//

import Foundation
import SwiftData

extension DataClient {
    
    @MainActor
    func addCars(_ cars: [CarResponse]) {
        guard cars.count > 0 else { return }
        
        for car in cars {
            var drivers: [RaceCarDriverItem] = []
            for driver in car.drivers {
                drivers.append(RaceCarDriverItem(name: driver.name, country: driver.country))
            }
            
            let item = RaceCarItem(carId: car.carId, team: car.team, car: car.car, type: car.type, drivers: drivers, stream: car.stream)
            
            self.modelContainer.mainContext.insert(item)
        }
    }
    
    @MainActor
    func getOwnCars() -> [RaceCarItem] {
        let predicate = #Predicate<RaceCarItem> { $0.type == "own" }
        let sortDescriptor = [SortDescriptor(\RaceCarItem.carId)]
        let descriptor = FetchDescriptor<RaceCarItem>(predicate: predicate, sortBy: sortDescriptor)
        let items = try? modelContainer.mainContext.fetch(descriptor)

        return items ?? []
    }
    
    @MainActor
    func getCompetitorCars() -> [RaceCarItem] {
        let predicate = #Predicate<RaceCarItem> { $0.type == "competitor" }
        let sortDescriptor = [SortDescriptor(\RaceCarItem.carId)]
        let descriptor = FetchDescriptor<RaceCarItem>(predicate: predicate, sortBy: sortDescriptor)
        let items = try? modelContainer.mainContext.fetch(descriptor)

        return items ?? []
    }
    
    @MainActor
    func getCar(by id: String) -> RaceCarItem? {
        let predicate = #Predicate<RaceCarItem> { $0.carId == id }
        let sortDescriptor = [SortDescriptor(\RaceCarItem.carId)]
        let descriptor = FetchDescriptor<RaceCarItem>(predicate: predicate, sortBy: sortDescriptor)
        if let item = try? modelContainer.mainContext.fetch(descriptor).first {
            return item
        }

        return nil
    }
}
