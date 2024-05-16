import Foundation
import RealityKit
import RealityKitContent
import Observation
import SwiftUI
import CoreLocation

@Observable
final class Racetrack {
    public static let shared = Racetrack()
    
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
            
            // Add cars to cars container
            carViewModel.setupMockData()
            
            for car in carViewModel.cars {
                // Add all cars
                carsContainer.addChild(car.entity)
            }
            
            // Add track and cars to main container
            mainContainer.addChild(trackContainer)
            mainContainer.addChild(carsContainer)
            
            return mainContainer
            
        } catch {
            print("Error in RealityView's make: \(error)")
            fatalError()
        }
    }
    
    public func updateCarPosition() {
        for car in carViewModel.cars {
            let referenceLocation = car.getReferenceLocation()
            let currentLocation = car.currentLocation
            let latitude = referenceLocation.latitude
            let longitude = referenceLocation.longitude
       
            // show or hide a car
            car.entity.isEnabled = car.visible
            
            if currentLocation.index != car.currentIndex {
                if currentLocation.index > 0 {
                    let currentGPSLocation = CLLocation(latitude: latitude, longitude: longitude)
                    let distance = currentGPSLocation.distance(from: CLLocation(latitude: referenceLocation.latitude, longitude: referenceLocation.longitude))
                    
                    if distance == 0.0 {
                        // Skipping location update
                        return
                    }
                }
            }
            
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
            
            // Set car position and orientation animated
            var carTransform = car.entity.transform
            
            let previousLapLocation: SIMD3<Float> = carTransform.translation
            let currentLapLocation: SIMD3<Float> = .init(x: trackCoordinate.x, y: carYPos, z: trackCoordinate.z)
            
            if let angle = carViewModel.calculateAngle(previous: previousLapLocation, current: currentLapLocation) {
                carTransform.rotation = simd_quatf(angle: angle, axis: SIMD3<Float>(0,1,0))
            }
            car.entity.position = .init(x: trackCoordinate.x, y: carYPos, z: trackCoordinate.z)
        }
    }
    
    public func removeCarFromTrack(id: UUID) {
        carViewModel.cars.forEach { car in
            if car.id == id {
                car.visible = !car.visible
            }
        }
    }
    public func addNewCarToTrack() {
        carViewModel.addNewCar()
        if let car = carViewModel.cars.last {
            carsContainer.addChild(car.entity)
        }
    }
    
    public func cars() -> [Car] {
        return carViewModel.cars
    }
}
