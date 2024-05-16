//
//  JSONParser.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 15/05/2024.
//

import Foundation

public struct JSONParser<T: Decodable>: Parser {
    public typealias ItemType = T
    public init() {}
    public func parse(data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    public static func read(file: String) -> Data? {
        if let url = Bundle.main.url(forResource: file, withExtension: "json") {
            return try? Data(contentsOf: url)
        }
        return nil
    }
}
