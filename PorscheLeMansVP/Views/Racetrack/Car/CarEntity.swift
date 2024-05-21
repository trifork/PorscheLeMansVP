import Foundation
import RealityKit
import RealityKitContent
import SwiftUI

@Observable
final class CarEntity {
    @MainActor
    public func entity(trackViewModel: TrackViewModel) async throws -> Entity {
        do {
            let carEntity = try await Entity(named: trackViewModel.carName, in: realityKitContentBundle)
            carEntity.components.set(ImageBasedLightReceiverComponent(imageBasedLight: carEntity))
            carEntity.transform.scale *= trackViewModel.carScale
            carEntity.name = "CarEntity"
           
            // Add lighting
            if trackViewModel.addLighting {
                do {
                    let resource = try await EnvironmentResource(named: "Environment")
                    let lightComponent = ImageBasedLightComponent(
                        source: .single(resource),
                        intensityExponent: 0.0)
                    carEntity.components.set(lightComponent)
                    carEntity.components.set(ImageBasedLightReceiverComponent(imageBasedLight: carEntity))
                } catch {
                    print("Error in RealityView's make: \(error)")
                }
            }
            return carEntity
        } catch {
            print("Error in RealityView's make: \(error)")
            fatalError()
        }
    }
    
    @MainActor
    public func porscheEntity() async throws -> Entity {
        do {
            let carEntity = try await Entity(named: "Porsche_963", in: realityKitContentBundle)
            carEntity.components.set(ImageBasedLightReceiverComponent(imageBasedLight: carEntity))
            carEntity.transform.scale *= 0.5
            return carEntity
        } catch {
            print("Error in RealityView's make: \(error)")
            fatalError()
        }
    }
        
    @MainActor
    public func dotEntity(color: UIColor) -> Entity {
        let material = SimpleMaterial(color: color, isMetallic: false)
        let carEntity = ModelEntity(mesh: .generateSphere(radius: 0.03), materials: [material])
        carEntity.generateCollisionShapes(recursive: true)
        
        return carEntity
    }
}
