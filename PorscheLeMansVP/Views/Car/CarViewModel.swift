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
import ARKit

@Observable public final class CarViewModel {
    private var trackViewModel = TrackViewModel()
    
    public var cars: [Car] = []

    public func setupMockData() {
        cars = CarsMockData.shared.cars()
    }
    
    public func addNewCar() {        
        cars.append(CarsMockData.shared.newCar())
    }
    
    public func createNewCar(color: UIColor, id: String) -> ModelEntity {
        let material = SimpleMaterial(color: color, isMetallic: false)
        
        let car = ModelEntity(mesh: .generateSphere(radius: 0.03), materials: [material])
        car.generateCollisionShapes(recursive: true)
        car.name = "car_\(id)"

        return car
    }
    
    @MainActor
    public func createPorscheCar(id: String) async throws -> Entity {
        do {
            let car = try await Entity(named: "Porsche_963", in: realityKitContentBundle)
            car.name = "car_\(id)"
            car.components.set(ImageBasedLightReceiverComponent(imageBasedLight: car))
            return car
        } catch {
            return Entity()
        }
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

