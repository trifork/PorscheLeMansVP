import Foundation
import RealityKit
import RealityKitContent

@Observable
final class TrackEntity {    
    @MainActor
    public func entity(trackViewModel: TrackViewModel) async throws -> Entity {
        do {
            let trackEntity = try await Entity(named: trackViewModel.trackName, in: realityKitContentBundle)
            trackEntity.name = "TrackEntity"
           
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
            return trackEntity
        } catch {
            print("Error in RealityView's make: \(error)")
            fatalError()
        }
    }
}

