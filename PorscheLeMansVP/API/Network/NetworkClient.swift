//
//  NetworkClient.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 15/05/2024.
//

import Foundation

public class NetworkClient {
    public static let shared = NetworkClient()
    
    public let baseURL = "https://query1.finance.yahoo.com"
    
    private let httpClient: HTTPClient = HTTPClient()
    private var task: URLSessionDataTask?
    
    public func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>, HTTPURLResponse?) -> Void) {
        let request = URLRequest(endpoint: endpoint)
        
        self.task = httpClient.send(request: request) { (result: Result<T, Error>, response) in
            completion(result, response)
        }
        task?.resume()
    }
}
