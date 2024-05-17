//
//  WebSocketEndpoint.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 17/05/2024.
//

import Foundation

public enum WebSocketEndpoint: Endpoint {
    
    case connect
    
    public var host: URL {
        return URL(string: NetworkClient.shared.wssURL)!
    }

    public var path: String {
        switch self {
        case .connect: return ""
        }
    }
    
    public var method: HTTPMethod {
        return .get
    }
    
    public var queryItems: [URLQueryItem]? {
        return nil
    }
    
    public var body: Data? {
        return nil
    }
    
    public var headers: [String: String]? {
        return nil
    }
}
