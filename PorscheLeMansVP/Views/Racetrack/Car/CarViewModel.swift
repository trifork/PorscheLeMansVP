import Foundation
import SwiftUI

@Observable public final class CarViewModel {
    private var trackViewModel = TrackViewModel()
    private var carEntity = CarEntity()
    
    public var cars: [Car] = []
    
    @MainActor
    public func setupMockData() async {
        do {
            let entity = try await carEntity.entity(trackViewModel: trackViewModel)
            let car = Car(visible: true, entity: entity, currentLocation: currentLocation())
            cars.append(car)
        } catch { }
        
        // Add more cars
        // addNewCar(color: .cyan)
        // addNewCar(color: .yellow)
        // addNewCar(color: .orange)
    }
    
    @MainActor
    public func addNewCar(color: UIColor = UIColor.random) {
        let entity = carEntity.dotEntity(color: color)
        let car = Car(visible: true, entity: entity, currentLocation: currentLocation())
        cars.append(car)
    }
    
    @MainActor
    private func currentLocation() -> ReferenceLocation {
        let latitude = Double(DataClient.shared.getCSVItem(for: 0)?.aLongGPSFIARx ?? 0.0)
        let longitude = Double(DataClient.shared.getCSVItem(for: 0)?.aLatGPSFIARx ?? 0.0)
        
        return ReferenceLocation(index: 0, latitude: latitude, longitude: longitude)
    }

    public func calculateAngle(previous: SIMD3<Float>, current: SIMD3<Float>) -> Float? {
        let calcAtan2 = -atan2(previous.z - current.z, previous.x - current.x)
        
        if calcAtan2 != -0.0 {
            let angle = calcAtan2 + (.pi/2.0)
            return angle
        }
        return nil
    }
}

extension UIColor {
    public static var random: UIColor {
        return UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
    }
}
