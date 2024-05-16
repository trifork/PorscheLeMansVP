import Foundation
import RealityKit

public class Car: Identifiable {
    public var id = UUID()
    public var visible:Bool
    public var entity: Entity
    public var currentLocation: ReferenceLocation
    public var currentIndex: Int
    
    init(visible: Bool, entity: Entity, currentLocation: ReferenceLocation, currentIndex: Int = 0) {
        self.visible = visible
        self.entity = entity
        self.currentLocation = currentLocation
        self.currentIndex = currentIndex
    }
    
    @MainActor public func getReferenceLocation() -> ReferenceLocation {
        if let latitude = DataClient.shared.getCSVItem(for: self.currentIndex)?.aLatGPSFIARx,
           let longitude = DataClient.shared.getCSVItem(for: self.currentIndex)?.aLongGPSFIARx {
            let referenceLocation = ReferenceLocation(index: self.currentIndex, latitude: latitude, longitude: longitude)
            self.currentIndex += 1
            return referenceLocation
        } else {
            self.currentIndex += 1
            return currentLocation
        }
    }
}
