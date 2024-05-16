//
//  HTTPClient.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 15/05/2024.
//

import Foundation

public class HTTPClient: HTTPClientProtocol {
    
    private let session: URLSession!
    private let errorHandler: URLErrorHandler!

    public init(configuration: URLSessionConfiguration = URLSessionConfiguration.default, errorHandler: URLErrorHandler = HTTPClientErrorHandler(), protocolClass: AnyClass? = nil, additionalHeaders: [String: String]? = [:]) {
        if let protocolClass = protocolClass {
            configuration.protocolClasses?.insert(protocolClass, at: 0)
        }
        configuration.timeoutIntervalForRequest = 60
        configuration.httpAdditionalHeaders = additionalHeaders
        
        self.session = URLSession(configuration: configuration)
        self.errorHandler = errorHandler
    }
    
    /**
     Perform a request with an expected JSON response.
     */
    @discardableResult
    public func send<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask {
        let parser = JSONParser<T>()
        let task = send(request: request, parser: parser) { result, _ in
            completion(result)
        }
        return task
    }
    
    @discardableResult
    public func send<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>, HTTPURLResponse?) -> Void) -> URLSessionDataTask {
        let parser = JSONParser<T>()
        let task = send(request: request, parser: parser) { result, response in
            completion(result, response)
        }
        return task
    }
    
    /**
     Perform a request with a custom parser.
     */
    @discardableResult
    public func send<P: Parser>(request: URLRequest, parser: P, completion: @escaping (Result<P.ItemType, Error>, HTTPURLResponse?) -> Void) -> URLSessionDataTask {
        guard let url = request.url?.absoluteString else {
            log(message: "Missing URL in `URLRequest` function: \(#function) line: \(#line)", level: .error)
            completion(.failure(HTTPClientError.cancelled), nil)
            fatalError()
        }
        
        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }
            do {
                switch (response, error) {
                case (let response as HTTPURLResponse, nil) where (200...299).contains(response.statusCode):
                    switch (data) {
                    case (let data?) where data.count > 0:
                        //log(message: "Data loaded for \(url), Trying to parse...", level: .info) // String(data: data!, encoding: .utf8)
                        
                        let model = try parser.parse(data: data)
                        DispatchQueue.main.async {
                            log(message: "Success! \(url) \(Date().fullTimeMS)", level: .custom("✅"))
                            completion(Result.success(model), response)
                        }
                    case (let data?) where data.count == 0:
                        let model = try parser.parse(data: "{}".data(using: .utf8)!)
                        DispatchQueue.main.async {
                            log(message: "Success! Request for \(url) success with empty `data` \(Date().fullTimeMS)", level: .custom("✅"))
                            completion(Result.success(model), response)
                        }
                    default:
                        DispatchQueue.main.async {
                            log(message: "Failed! Request for \(url) failed because the response `data` was empty", level: .error)
                            completion(Result.failure(HTTPClientError.emptyData(statusCode: response.statusCode)), response)
                        }
                    }
                    
                default:
                    let error = strongSelf.errorHandler.handle(response: response, data: data, error: error)
                    DispatchQueue.main.async {
                        log(message: "Failed! \((response as? HTTPURLResponse)?.statusCode ?? 0) \(url) error: \(error) msg: \((error as? HTTPClientError)?.message ?? "-")", level: .error)
                        completion(Result.failure(error), (response as? HTTPURLResponse))
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(Result.failure(error), (response as? HTTPURLResponse))
                    log(message: "Failed! \((response as? HTTPURLResponse)?.statusCode ?? 0) \(url) error: \(error)", level: .error)
                }
            }
        }
        task.resume()
        return task
        
    }
}

