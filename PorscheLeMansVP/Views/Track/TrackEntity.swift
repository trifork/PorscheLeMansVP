import Foundation
import RealityKit
import RealityKitContent
import Observation
import SwiftUI
import CoreLocation

@Observable
final class TrackEntity {
    public static let shared = TrackEntity()
    
    private var mainContainer = Entity() // Containing track and cars
    private var trackContainer = Entity() // Containing track
    private var carsContainer = Entity() // Containing all cars
    
    private var trackEntity = Entity()
    
    private let trackViewModel = TrackViewModel()
    private let carViewModel = CarViewModel()
    
    public var currentCarLocationIndex = 0
    
    @MainActor
    public func entity() async throws -> Entity {
        do {
            trackEntity = try await Entity(named: trackViewModel.trackName, in: realityKitContentBundle)
            trackEntity.name = "TrackEntity"
            
            //trackEntity.transform.rotation = simd_quatf(angle: trackViewModel.trackRotation, axis: SIMD3<Float>(0,1,0))
            // trackEntity.transform.scale *= trackViewModel.trackScale
            
            // Add lighting
            if trackViewModel.addLighting {
                do {
                    let resource = try await EnvironmentResource(named: "Environment")
                    let lightComponent = ImageBasedLightComponent(
                        source: .single(resource),
                        intensityExponent: 0.0)
                    trackEntity.components.set(lightComponent)
                    trackEntity.components.set(ImageBasedLightReceiverComponent(imageBasedLight: trackEntity))
                } catch {
                    print("Error in RealityView's make: \(error)")
                }
            }
            
            // Setup collision filter
            let collisionFilter = CollisionFilter(group: trackViewModel.collisionGroup, mask: .all)
            for collisionsEntityName in trackViewModel.collisionsEntityNames {
                let tarmac = trackEntity.findEntity(named: collisionsEntityName)
                if let entity = tarmac?.children[0] {
                    var components = entity.components
                    
                    if var collisionComponent = components[CollisionComponent.self] {
                        // There is already a collision component. Set the filter on it.
                        collisionComponent.filter = collisionFilter
                        components[CollisionComponent.self] = collisionComponent
                        entity.components = components
                    } else if let modelComponent = components[ModelComponent.self] {
                        // There is no collision component. Add one
                        let shape = try? await ShapeResource.generateConvex(from: modelComponent.mesh)
                        if let shape = shape {
                            let collisionComponent = CollisionComponent(shapes: [shape], filter: collisionFilter)
                            components[CollisionComponent.self] = collisionComponent
                            entity.components = components
                        }
                    }
                }
            }
            
            // Add cars to cars container
            carViewModel.setupMockData()
            
            for car in carViewModel.cars {
                carsContainer.addChild(car.entity)
            }
            
            // Add track and cars to main container
            mainContainer.addChild(trackEntity)
            mainContainer.addChild(carsContainer)
            
            return mainContainer
        } catch {
            print("Error in RealityView's make: \(error)")
            fatalError()
        }
    }
    
    public func updateCarPosition() {
        for car in carViewModel.cars {
            let referenceLocation = car.referenceLocation[currentCarLocationIndex]
            let currentLocation = car.currentLocation
            let latitude = referenceLocation.latitude
            let longitude = referenceLocation.longitude
            // let visible = car.visible
            
            if currentLocation.index != currentCarLocationIndex {
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
            let currentCarPosition = carsContainer.position
            
            let fromRayCastPosition = SIMD3<Float>(x: trackCoordinate.x, y: 0.5, z: trackCoordinate.z)
            let toRayCastPosition = SIMD3<Float>(x: trackCoordinate.x, y: -0.3, z: trackCoordinate.z)
            
            var carYPos: Float = currentCarPosition.y // Keep previous y, if no tarmac is detected
            
            if trackViewModel.debugMode {
                //////////////// DEBUG COLLISIONS ///////////////////
                let fromShapeEntity = ModelEntity(mesh: trackViewModel.trackCollisionDetectionMesh, materials: [SimpleMaterial(color: .blue, isMetallic: false)])
                trackContainer.addChild(fromShapeEntity)
                let toShapeEntity = ModelEntity(mesh: trackViewModel.trackCollisionDetectionMesh, materials: [SimpleMaterial(color: .green, isMetallic: false)])
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
                        let color: UIColor = collisions.count > 1 ? .red : .cyan
                        let collisionShape = ModelEntity(mesh: trackViewModel.trackCollisionDetectionMesh, materials: [SimpleMaterial(color: color, isMetallic: false)])
                        collisionShape.position = collision.position
                        trackContainer.addChild(collisionShape)
                        //////////////// DEBUG COLLISIONS ///////////////////
                    }
                    carYPos = collision.position.y
                }
            }
            
            // Set car position and orientation animated
            var carTransform = carsContainer.transform
            
            let previousLapLocation: SIMD3<Float> = carTransform.translation
            let currentLapLocation: SIMD3<Float> = .init(x: trackCoordinate.x, y: carYPos, z: trackCoordinate.z)
            
            if let angle = carViewModel.calculateAngle(previous: previousLapLocation, current: currentLapLocation) {
                carTransform.rotation = simd_quatf(angle: angle, axis: SIMD3<Float>(0,1,0))
            }
            carsContainer.position = .init(x: trackCoordinate.x, y: carYPos, z: trackCoordinate.z)
        }        
        currentCarLocationIndex += 1
    }
}
