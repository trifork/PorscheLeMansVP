//
//  HTTPClientError.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 15/05/2024.
//

import Foundation

public enum HTTPClientError: Error {
    case noConnection
    case networkConnectionLost
    case timedOut
    case cancelled
    case emptyData(statusCode: Int)
    case responseError(response: HTTPURLResponse, data: Data?)
    case requestError(error: Error)
    case badRequest
    case unauthorized
    case forbidden
    case missingToken
    case unknown
    case APIError(model: ErrorModel)
    
    public var title: String {
        switch self {
        case .noConnection, .networkConnectionLost:
            return ""
        case .timedOut:
            return ""
        case .badRequest:
            return "400 encountered"
        case .unauthorized:
            return "401 encountered"
        case .forbidden:
            return "403 encountered"
        case .unknown:
            return "unknown error"
        case .APIError(let model):
            return "error msg: \(model.message ?? "")"
        default:
            return ""
        }
    }
    
    public var message: String {
        switch self {
        case .noConnection, .networkConnectionLost:
            return ""
        case .timedOut:
            return ""
        case .responseError(let response, _):
            return "error code \(response.statusCode)."
        case .requestError(let error as NSError):
            return "error code \(error.code)."
        case .badRequest:
            return "Bad request"
        case .unauthorized:
            return "Refresh OAuth2 token"
        case .unknown:
            return "unknown"
        case .APIError(let model):
            return model.message ?? ""
        default:
            return ""
        }
    }
}
