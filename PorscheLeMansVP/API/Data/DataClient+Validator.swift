//
//  DataClient+Validator.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 14/05/2024.
//

import Foundation
import SwiftData
import CoreData

extension DataClient {
    
    @MainActor
    func isModified(of type: AnyClass, notification: NotificationCenter.Publisher.Output) -> Bool {
        if let objects = notification.userInfo?["inserted"] as? Set<NSManagedObject> {
            var result: Bool = false
            for object in objects {
                if object.entity.name == String(describing: type) {
                    result = true
                }
            }
            return result
        } else if let objects = notification.userInfo?["updated"] as? Set<NSManagedObject> {
            var result: Bool = false
            for object in objects {
                if object.entity.name == String(describing: type) {
                    result = true
                }
            }
            return result
        }
        
        return false
    }
}
