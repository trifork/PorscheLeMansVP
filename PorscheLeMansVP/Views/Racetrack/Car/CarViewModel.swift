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

@MainActor
@Observable public final class CarViewModel {
    private var trackViewModel = TrackViewModel()
    
    public var cars: [Car] = []

    public func setupMockData() {
        let car1 = Car(visible: true, entity: createNewCar(color: .red), currentLocation: currentLocation())
        cars = [car1]
    }
    
    public func addNewCar() {
        let car = Car(visible: true, entity: createNewCar(color: .cyan), currentLocation: currentLocation())
        cars.append(car)
    }
        
    private func currentLocation() -> ReferenceLocation {
        let latitude = Double(DataClient.shared.getCSVItem(for: 0)?.aLongGPSFIARx ?? 0.0)
        let longitude = Double(DataClient.shared.getCSVItem(for: 0)?.aLatGPSFIARx ?? 0.0)
        
        return ReferenceLocation(index: 0, latitude: latitude, longitude: longitude)
    }

    public func createNewCar(color: UIColor) -> ModelEntity {
        let material = SimpleMaterial(color: color, isMetallic: false)
        
        let car = ModelEntity(mesh: .generateSphere(radius: 0.03), materials: [material])
        car.generateCollisionShapes(recursive: true)

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

