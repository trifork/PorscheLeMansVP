//
//  CarViewModel.swift
//  PorscheLeMansVP
//
//  Created by Smajo Zukanovic on 14/05/2024.
//

import Foundation
import SwiftUI
import RealityKit
import RealityKitContent
import CoreLocation

@Observable public final class CarViewModel {
    private var trackViewModel = TrackViewModel()
    
    public var cars: [Car] = []

    public func setupMockData() {
        cars = CarsMockData.shared.cars()
    }
    
    public func createNewCar(color: UIColor, id: String) -> ModelEntity {
        let material = SimpleMaterial(color: color, isMetallic: false)
        
        let car = ModelEntity(mesh: .generateSphere(radius: 0.03), materials: [material])
        car.name = "car_\(id)"
        
        return car
    }
    
    public func calculateAngle(previous: SIMD3<Float>, current: SIMD3<Float>) -> Float? {
        let calcAtan2 = -atan2(previous.z - current.z, previous.x - current.x)
        
        if calcAtan2 != -0.0 {
            let angle = calcAtan2 + (.pi/2.0)
            return angle
        }
        return nil
    }
    
   
}

