import SwiftUI
import RealityKit

public class LineEntity {
    
    public static func lineFrom(_ from: Entity, to: Entity) -> ModelEntity {
        // size is equal to the distance between two entities
        let startPoint = from.position
        let endPoint = to.position
        let distance = distance(startPoint, endPoint)-0.003
        
        let rectangle = ModelEntity(mesh: .generateBox(width: 0.001, height: 0.001, depth: distance), materials: [SimpleMaterial(color: UIColor(.white.opacity(0.6)), isMetallic: false)])
        rectangle.name = "Line"
        
        // middle point of two points
        let middlePoint : simd_float3 = simd_float3((startPoint.x + endPoint.x)/2, (startPoint.y + endPoint.y)/2, (startPoint.z + endPoint.z)/2)
                
        rectangle.position = middlePoint
        rectangle.look(at: startPoint, from: middlePoint, relativeTo: nil)
        
        return rectangle
    }
}
