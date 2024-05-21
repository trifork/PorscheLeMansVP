import Foundation
import RealityKit
import SwiftUI
import CoreLocation

@Observable final class Racetrack {    
    private var trackEntity = Entity()
    private var mainContainer = Entity() // Containing track and cars
    private var trackContainer = Entity() // Containing track
    private var carsContainer = Entity() // Containing all cars
   
    private let trackViewModel = TrackViewModel()
    private let carViewModel = CarViewModel()
    private let track = TrackEntity()
    
    @MainActor
    public func entity() async throws -> Entity {
        do {
            // Add track
            trackEntity = try await track.entity(trackViewModel: trackViewModel)
            trackContainer.addChild(trackEntity)
           
            // Get all cars
            await carViewModel.setupCarkData()
            
            for car in carViewModel.cars {
                let carInfoContainer = ModelEntity(mesh: MeshResource.generateBox(size:0))
                carInfoContainer.name = "CarInfoContainer_\(car.id)"
                carInfoContainer.addChild(car.entity)
                
                carsContainer.addChild(carInfoContainer)
            }
            
            // Add track and cars to main container
            mainContainer.addChild(trackContainer)
            mainContainer.addChild(carsContainer)
            
            return mainContainer
            
        } catch {
            log(message: "Error in RealityView's make: \(error)", level: .error)
            fatalError()
        }
    }
    
    @MainActor
    public func updateCarPosition() {
        for car in carViewModel.cars {
            let modelEntity = car.entity
            let referenceLocation = car.getReferenceLocation()
            let latitude = referenceLocation.latitude
            let longitude = referenceLocation.longitude
            
            // show or hide a car
            modelEntity.isEnabled = car.visible
   
//            if car.currentLocation.index != car.currentIndex {
//                if car.currentLocation.index > 0 {
//                    let currentGPSLocation = CLLocation(latitude: latitude, longitude: longitude)
//                    let distance = currentGPSLocation.distance(from: CLLocation(latitude: referenceLocation.latitude, longitude: referenceLocation.longitude))
//                    
//                    if distance == 0.0 {
//                        // Skipping location update
//                        return
//                    }
//                }
//            }
            
            let trackCoordinate = CoordinateConverter.convert(latitude: latitude, longitude: longitude, referenceLocation: trackViewModel.trackReferenceLocation, xFactor: trackViewModel.xFactor, zFactor: trackViewModel.zFactor)
            let currentCarPosition = car.entity.position
            
            let fromRayCastPosition = SIMD3<Float>(x: trackCoordinate.x, y: 0.5, z: trackCoordinate.z)
            let toRayCastPosition = SIMD3<Float>(x: trackCoordinate.x, y: -0.5, z: trackCoordinate.z)
            
            var carYPos: Float = currentCarPosition.y // Keep previous y, if no tarmac is detected
            
            if trackViewModel.debugMode {
                //////////////// DEBUG COLLISIONS ///////////////////
                let fromShapeEntity = ModelEntity(mesh: trackViewModel.trackCollisionDetectionMesh, materials: [SimpleMaterial(color: .yellow, isMetallic: false)])
                trackContainer.addChild(fromShapeEntity)
                let toShapeEntity = ModelEntity(mesh: trackViewModel.trackCollisionDetectionMesh, materials: [SimpleMaterial(color: .yellow, isMetallic: false)])
                trackContainer.addChild(toShapeEntity)
                fromShapeEntity.position = fromRayCastPosition
                toShapeEntity.position = toRayCastPosition
                trackContainer.addChild(LineEntity.lineFrom(fromShapeEntity, to: toShapeEntity))
                //////////////// DEBUG COLLISIONS ///////////////////
            }
            
            if let collisions = mainContainer.scene?.raycast(from: fromRayCastPosition, to: toRayCastPosition, mask: trackViewModel.collisionGroup, relativeTo: trackContainer) {
                if let collision = collisions.first {
                    if trackViewModel.debugMode {
                        //////////////// DEBUG COLLISIONS ///////////////////
                        let color: UIColor = collisions.count > 1 ? .red : .green
                        let collisionShape = ModelEntity(mesh: trackViewModel.trackCollisionDetectionMesh, materials: [SimpleMaterial(color: color, isMetallic: false)])
                        collisionShape.position = collision.position
                        trackContainer.addChild(collisionShape)
                        //////////////// DEBUG COLLISIONS ///////////////////
                    }
                    carYPos = collision.position.y
                }
            }
            
            if let carInfo = modelEntity.parent {
                // Set car position and orientation animated
                let previousLapLocation: SIMD3<Float> = carInfo.transform.translation
                let currentLapLocation: SIMD3<Float> = .init(x: trackCoordinate.x, y: carYPos, z: trackCoordinate.z)
                
                if let angle = carViewModel.calculateAngle(previous: previousLapLocation, current: currentLapLocation) {
                    modelEntity.transform.rotation = simd_quatf(angle: angle, axis: SIMD3<Float>(0,1,0))
                }
                
                // Move car without animations
                //carInfo.position = .init(x: trackCoordinate.x, y: carYPos, z: trackCoordinate.z)
                
                // Animate car
                var transform = carInfo.transform
                transform.translation = currentLapLocation
                let animationDefinition = FromToByAnimation(to: transform, bindTarget: .transform)
                let animationViewDefinition = AnimationView(source: animationDefinition, delay: 0, speed: 1.0)
                let animationResource = try! AnimationResource.generate(with: animationViewDefinition)
                carInfo.playAnimation(animationResource)
            }
        }
    }
    
    public func hideCompetitorCars(visible: Bool) {
        carViewModel.cars.forEach { car in
            if car.own == false {
                car.visible = visible
            }
        }
    }
        
    public func cars() -> [Car] {
        return carViewModel.cars
    }
    
    public func carEntity(by id: String) -> Entity? {
        return carViewModel.cars.first(where: { $0.id == id })?.entity
    }
    
    public func carInfoEntity(by id: String) -> Entity? {
        return carsContainer.children.first(where: { $0.name == "CarInfoContainer_\(id)" })
    }    
}

