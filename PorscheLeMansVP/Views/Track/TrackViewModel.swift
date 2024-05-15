import Foundation
import RealityKit
import RealityKitContent

@Observable
final class TrackViewModel {
    public let debugMode: Bool = true
    public let addLighting: Bool = false
    
    public var trackReferenceLocation: ReferenceLocation = ReferenceLocation(index: -1, latitude: 47.94988, longitude: 0.20754)
    public let xFactor: Double = -0.002784
    public let zFactor: Double = 0.002175
    public let trackRotation: Float = 0.18
    
    public let trackName: String = "LeMansTrack"
    public let trackScale: Float = 1.0
    public let trackCollisionDetectionMesh: MeshResource = MeshResource.generateSphere(radius: 0.003)
    public let collisionGroup: CollisionGroup = CollisionGroup(rawValue: 1 << 1)
    public let collisionsEntityNames: [String] = ["TERRAIN_TARMAC_MAIN_00_road_24H_0", "TERRAIN_TARMAC_MAIN_01_road_24H_0", "TERRAIN_TARMAC_MAIN_04_road_24H_0", "TERRAIN_TARMAC_MAIN_05_road_24H_0", "TERRAIN_TARMAC_MAIN_06_road_24H_0", "TERRAIN_TARMAC_MAIN_07_road_24H_0"]
}
