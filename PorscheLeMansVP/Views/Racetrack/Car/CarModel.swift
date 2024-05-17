import Foundation
import RealityKit

public class Car {
    public var id: String
    public var own:Bool
    public var visible:Bool
    public var entity: Entity
    public var currentLocation: ReferenceLocation
    public var currentIndex: Int
    
    init(id: String, own: Bool, visible: Bool, entity: Entity, currentLocation: ReferenceLocation, currentIndex: Int = 0) {
        self.id = id
        self.own = own
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
            self.currentIndex = 0
            return currentLocation
        }
    }
}
