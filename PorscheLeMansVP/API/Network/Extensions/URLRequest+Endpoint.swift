//
//  URLRequest+Endpoint.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 15/05/2024.
//

import Foundation

public extension URLRequest {
    
    init(endpoint: Endpoint) {
        var url = endpoint.host
        url = url.appendingPathComponent(endpoint.path)
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = endpoint.queryItems
        
        self.init(url: urlComponents.url!)
        self.httpMethod = endpoint.method.rawValue
        self.allHTTPHeaderFields = endpoint.headers
        self.httpBody = endpoint.body
    }
    
    mutating func append(additionalHeaders: [String: String]) {
        allHTTPHeaderFields?.merge(additionalHeaders) { (_, new) in new }
    }
}
