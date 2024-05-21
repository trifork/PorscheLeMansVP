import Foundation
import RealityKit
import RealityKitContent
import ARKit
import SwiftUI

@Observable
final class Carousel {
    public var carsPlatform: ModelEntity = ModelEntity()
    private let carsContainer = Entity()
    
    private let platformHeight: Float = 0.005
    private let platformRadius: Float = 0.40
    private let platformContainerScale: Float = 1/11
    private var carsPlatformIntialDegrees: Float = 135
    private var carsRotationHandler = RotatePlatformHandler()

    @MainActor
    public func entity() async throws -> Entity {
        let carsInputComponent = InputTargetComponent(allowedInputTypes: .all)
        
        carsPlatform = ModelEntity(mesh: .generateCylinder(height: platformHeight / platformContainerScale, radius: platformRadius / platformContainerScale), materials: [Materials.platformMaterial()])
        carsPlatform.name = "carsPlatform"
        carsPlatform.generateCollisionShapes(recursive: true)
        carsPlatform.components.set(carsInputComponent)
        carsPlatform.position = [0.0, 0.0, 0.0]
        carsContainer.addChild(carsPlatform)
        
        carsContainer.scale *= platformContainerScale
        carsContainer.position = [0.69, -0.01, -0.1]
        
        let carsPosition: [SIMD3<Float>] = [SIMD3<Float>(2.2,0,-1.5), SIMD3<Float>(-2.2,0,-1.5), SIMD3<Float>(0,0,2.2)]
        
        do {
            // Add car
            let carEntity = try await CarEntity().porscheEntity()
            var index: Int = 0
            
            for raceCar in DataClient.shared.getOwnCars() {
                let car = carEntity.clone(recursive: true)
                car.name = raceCar.carId
                car.position = carsPosition[index]
                
                // Used for tap gesture
                if let mainBody = car.findEntity(named: "Main_Body") {
                    mainBody.generateCollisionShapes(recursive: false)
                    mainBody.components.set(carsInputComponent)
                    mainBody.name = raceCar.carId
                }
              
                carsContainer.addChild(car)
                index += 1
            }
            
            // Platform rotation
            carsRotationHandler.configure(rotatingObject: carsContainer, platformSize: platformRadius, initialRotationDegrees: carsPlatformIntialDegrees)
            
            return carsContainer
            
        } catch {
            log(message: "Error in RealityView's make: \(error)", level: .error)
            fatalError()
        }
    }
    
    public func updateRotation(startPosition: Float, currentPosition: Float, pointsPerMeter: Float) {
        carsRotationHandler.updateRotation(startPosition: startPosition, currentPosition: currentPosition, pointsPerMeter: pointsPerMeter)
    }
    
    public func rotationEnded() {
        carsRotationHandler.rotationEnded()
    }
    
    public func selectCar(name: String) {
        carsContainer.children.forEach { child in
            let opacity: Float = child.name == name ? 1.0 : 0.3
            child.components[OpacityComponent.self] = .init(opacity: opacity)
        }
    }
}


