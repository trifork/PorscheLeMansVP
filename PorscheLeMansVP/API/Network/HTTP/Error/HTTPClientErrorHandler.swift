//
//  HTTPClientErrorHandler.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 15/05/2024.
//

import Foundation

public struct HTTPClientErrorHandler: URLErrorHandler {
    
    public init() {}
    
    public func handleServerResponse(_ response: HTTPURLResponse, data: Data?) throws -> Error {
        return HTTPClientError.responseError(response: response, data: data)
    }
    
}
