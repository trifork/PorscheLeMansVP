//
//  DataClient.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 13/05/2024.
//

import Foundation
import SwiftUI
import SwiftData

public class DataClient {
    public static let shared = DataClient()
    
    public var modelContainer: ModelContainer = {
        let schema = Schema([
            RaceDataItem.self,
            RaceContestantItem.self,
            TickerItem.self,
            CSVDataItem.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            // TODO: Fix if models is modified
            fatalError("Could not create ModelContainer: \(error.localizedDescription)")
        }
    }()
    
    @MainActor
    public func deleteAll() {
        try? modelContainer.mainContext.delete(model: RaceDataItem.self)
        try? modelContainer.mainContext.delete(model: RaceContestantItem.self)
        try? modelContainer.mainContext.delete(model: TickerItem.self)
        try? modelContainer.mainContext.delete(model: CSVDataItem.self)
    }

}
