import SwiftUI

public struct ReferenceLocation {
    public let index: Int
    public let latitude: Double
    public let longitude: Double

    public init(index: Int, latitude: Double, longitude: Double) {
        self.index = index
        self.latitude = latitude
        self.longitude = longitude
    }
}

public class CoordinateConverter {
    
    public static func convert(latitude: Double, longitude: Double, referenceLocation: ReferenceLocation, xFactor: Double, zFactor: Double) -> (x: Float, z: Float) {
        
        guard xFactor != 0, zFactor != 0 else {
            return (0.0, 0.0)
        }
        
        let diffX = referenceLocation.longitude - longitude;
        let diffZ = referenceLocation.latitude - latitude;
        
        return (Float(diffX/xFactor), Float(diffZ/zFactor))
    }
}
