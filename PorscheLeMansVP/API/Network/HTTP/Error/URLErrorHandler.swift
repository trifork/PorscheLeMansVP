//
//  URLErrorHandler.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 15/05/2024.
//

import Foundation

public protocol URLErrorHandler {
    func handle(response: URLResponse?, data: Data?, error: Error?) -> Error
    func handleServerResponse(_ response: HTTPURLResponse, data: Data?) throws -> Error
}

public extension URLErrorHandler {
    
    func handle(response: URLResponse?, data: Data?, error: Error?) -> Error {
        do {
            switch (response, error, data) {
            case (let response as HTTPURLResponse, nil, _) where response.statusCode == 400:
                return HTTPClientError.badRequest
                
            case (let response as HTTPURLResponse, nil, _) where response.statusCode == 401:
                return HTTPClientError.unauthorized
                
            case (let response as HTTPURLResponse, nil, _) where response.statusCode == 403:
                return HTTPClientError.forbidden
                
            case (let response as HTTPURLResponse, nil, nil):
                return try handleServerResponse(response, data: data)

            case (_, _, let data?):
                let errorModel = try JSONDecoder().decode(ErrorModel.self, from: data)
                return HTTPClientError.APIError(model: errorModel)
                
            case (_, let error as NSError, _):
                switch error.code {
                case NSURLErrorNotConnectedToInternet: return HTTPClientError.noConnection
                case NSURLErrorNetworkConnectionLost: return HTTPClientError.networkConnectionLost
                case NSURLErrorTimedOut: return HTTPClientError.timedOut
                case NSURLErrorCancelled: return HTTPClientError.cancelled
                default: return HTTPClientError.requestError(error: error)
                }
                
            default:
                // We should never get here, but we handle it if we do.
                let userInfo = [NSLocalizedDescriptionKey: "Unhandled error case in URLErrorHandler extension."]
                let error = NSError(domain: "ErrorDomain", code: 0, userInfo: userInfo)
                return error
            }
        } catch let error {
            // Return error thrown in the handleServerResponse method (e.g. JSON parse error).
            return error
        }
    }
    
}
