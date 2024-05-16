//
//  HTTPClientProtocol.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 15/05/2024.
//

import Foundation

public protocol HTTPClientProtocol {
    func send<P: Parser>(request: URLRequest, parser: P, completion: @escaping (Result<P.ItemType, Error>, HTTPURLResponse?) -> Void) -> URLSessionDataTask
    func send<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>, HTTPURLResponse?) -> Void) -> URLSessionDataTask
    func send<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask
}
