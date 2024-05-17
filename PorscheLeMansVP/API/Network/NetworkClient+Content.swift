//
//  NetworkClient+Content.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 16/05/2024.
//

import Foundation

extension NetworkClient {
    
    @MainActor public func getCars(_ success: @escaping (_ cars: [CarResponse]) -> Void, failure: @escaping (_ message: String) -> Void) async {
        
        // MOCK
        if let data = JSONParser<CarResponse>.read(file: "racecars") {
            do {
                let parser = JSONParser<[CarResponse]>()
                let model = try parser.parse(data: data)
                success(model)
            } catch let error {
                log(message: "Failed! \(error.localizedDescription)", level: .error)
                failure(error.localizedDescription)
            }
        } else {
            log(message: "Couldn't find/parse casecar json", level: .error)
            failure("Couldn't find/parse casecar json")
        }
        
        /*
        let endpoint = CarEndpoint.cars
        NetworkClient.shared.request(endpoint: endpoint) { (result: Result<[CarResponse], Error>, urlResponse: HTTPURLResponse?) in
            switch result {
            case .success:
                success()
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }*/
    }
    
}
