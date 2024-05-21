import Foundation
import SwiftUI

@Observable public final class CarViewModel {
    private var trackViewModel = TrackViewModel()
    private var carEntity = CarEntity()
    
    public var cars: [Car] = []
    
    @MainActor
    public func setupCarkData() async {
        var carIndex = 0
        
        do {
            for ownCar in DataClient.shared.getOwnCars() {
                let entity = try await carEntity.entity(trackViewModel: trackViewModel)
                let car = Car(id: ownCar.carId, own: true, visible: true, entity: entity, currentLocation: currentLocation(for: carIndex), currentIndex: carIndex)
                cars.append(car)
                
                carIndex = Int.random(in: 10...120)
            }
        } catch { }
        
        carIndex = 0
        
        for competitorCar in DataClient.shared.getCompetitorCars() {
            addNewCar(index: carIndex, id: competitorCar.carId)
            carIndex = Int.random(in: 22...79)
        }
    }
    
    @MainActor
    public func addNewCar(color: UIColor = UIColor.random, index: Int = 0, id: String) {
        let entity = carEntity.dotEntity(color: color)
        let car = Car(id: id, own: false, visible: true, entity: entity, currentLocation: currentLocation(), currentIndex: index)
        cars.append(car)
    }
    
    @MainActor
    private func currentLocation(for index: Int = 0) -> ReferenceLocation {
        let latitude = Double(DataClient.shared.getCSVItem(for: index)?.aLongGPSFIARx ?? 0.0)
        let longitude = Double(DataClient.shared.getCSVItem(for: index)?.aLatGPSFIARx ?? 0.0)
        
        return ReferenceLocation(index: index, latitude: latitude, longitude: longitude)
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
