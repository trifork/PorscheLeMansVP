import Foundation
import RealityKit
import RealityKitContent

@Observable
final class TrackViewModel {
    public let debugMode: Bool = false
    public let addLighting: Bool = true
    
    public var trackReferenceLocation: ReferenceLocation = ReferenceLocation(index: -1, latitude: 47.94988, longitude: 0.20754)
    public let xFactor: Double = -0.00984
    public let zFactor: Double = 0.007
    public let trackRotation: Float = 0.18
    
    public let trackName: String = "LeMansTrack"
    public let trackScale: Float = 1.0
    public let trackCollisionDetectionMesh = MeshResource.generateSphere(radius: 0.015)
    public let collisionGroup: CollisionGroup = CollisionGroup(rawValue: 1 << 1)
    public let collisionsEntityNames: [String] = ["TERRAIN_TARMAC_MAIN_00_road_24H_0", "TERRAIN_TARMAC_MAIN_01_road_24H_0", "TERRAIN_TARMAC_MAIN_04_road_24H_0", "TERRAIN_TARMAC_MAIN_05_road_24H_0", "TERRAIN_TARMAC_MAIN_06_road_24H_0", "TERRAIN_TARMAC_MAIN_07_road_24H_0"]
    
    public let carName: String = "Porsche_963"
    public let carScale: Float = 0.015
    
}
