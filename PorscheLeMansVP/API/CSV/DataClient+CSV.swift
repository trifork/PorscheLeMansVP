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
}
