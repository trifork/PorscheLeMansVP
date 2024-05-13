//
//  Collection+Safe.swift
//  SuperYachtVP
//
//  Created by Thomas Fekete Christensen on 27/03/2024.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    public subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
