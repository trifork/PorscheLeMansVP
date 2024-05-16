//
//  Parser.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 15/05/2024.
//

import Foundation

public protocol Parser {
    associatedtype ItemType
    func parse(data: Data) throws -> ItemType
}
