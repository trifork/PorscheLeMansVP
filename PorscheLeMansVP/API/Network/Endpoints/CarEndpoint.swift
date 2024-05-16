//
//  Endpoint.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 15/05/2024.
//

import Foundation

public enum CarEndpoint: Endpoint {
    
    case cars
    
    public var host: URL {
        return URL(string: NetworkClient.shared.baseURL)!
    }

    public var path: String {
        switch self {
        case .cars: return "cars"
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
