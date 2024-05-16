//
//  DataClient+CSV.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 15/05/2024.
//

import Foundation
import SwiftData

extension DataClient {
    
    @MainActor
    func insertFromCSV(_ item: CSVDataItem) {
        modelContainer.mainContext.insert(item)
    }
    
    @MainActor
    func getCSVItem(for index: Int) -> CSVDataItem? {
        let predicate = #Predicate<CSVDataItem> { $0.index == index }
        let descriptor = FetchDescriptor<CSVDataItem>(predicate: predicate)
        if let item = try? modelContainer.mainContext.fetch(descriptor).first {
            return item
        }

        return nil
    }
    
    @MainActor
    func getCSVItem(before index: Int, limit: Int? = nil) -> [CSVDataItem]? {
        let predicate = #Predicate<CSVDataItem> { $0.index <= index }
        var descriptor = FetchDescriptor<CSVDataItem>(predicate: predicate)
        if let limit = limit {
            descriptor.fetchLimit = limit
            descriptor.sortBy = [SortDescriptor(\CSVDataItem.index, order: .reverse)]
        }
        if let items = try? modelContainer.mainContext.fetch(descriptor) {
            return limit != nil ? items.reversed() : items
        }

        return nil
    }
    
}
