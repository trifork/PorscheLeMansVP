//
//  ErrorModel.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 15/05/2024.
//

import Foundation

public struct ErrorModel: Decodable {
    
    public var message: String?
    public var detailedMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case message
        case detailedMessage
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        detailedMessage = try values.decodeIfPresent(String.self, forKey: .detailedMessage)
    }
}
