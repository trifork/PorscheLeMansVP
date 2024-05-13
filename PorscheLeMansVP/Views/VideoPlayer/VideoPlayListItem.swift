//
//  VideoPlayListItem.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 03/04/2024.
//

import Foundation

public struct VideoPlayListItem: Identifiable {
    public let id = UUID()
    public let url: URL
    public let description: String?
}
