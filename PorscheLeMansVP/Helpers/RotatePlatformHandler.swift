//
//  RotatePlatformHandler.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 16/05/2024.
//

import RealityKit

struct RotatePlatformHandler {
    
    var rotatingObject: Entity?
    var platformSize: Float = 0.0
    var initialRotationAngle: Float = 0.0
    var currentRotationAngle: Float = 0.0
    
    private let rotationSpeed: Float = Platform.isSimulator ? 180.0 : 80.0 // Measured in degrees per platform size
    
    public mutating func configure(rotatingObject: Entity, platformSize: Float, initialRotationDegrees: Float) {
        self.rotatingObject = rotatingObject
        self.platformSize = platformSize
                
        self.initialRotationAngle = (initialRotationDegrees * Float.pi / 180.0)
        self.currentRotationAngle = initialRotationAngle
        
        rotatingObject.transform.rotation = simd_quatf(angle: initialRotationAngle, axis: SIMD3<Float>(0,1,0))
    }
    
    public func updateRotation(startPosition: Float, currentPosition: Float, pointsPerMeter: Float) {
        
        guard let rotatingObject = rotatingObject else { return }
        
        let distanceDragged = currentPosition - startPosition
        let metersDragged = Float(distanceDragged / pointsPerMeter)
        
        let rotateDegrees: Float = (metersDragged / platformSize) * rotationSpeed
        
        var newRotationValue = currentRotationAngle + (rotateDegrees * Float.pi / 180.0)
        if newRotationValue > Float.pi*2 {
            newRotationValue = newRotationValue - Float.pi*2
        } else if newRotationValue < 0 {
            newRotationValue = newRotationValue + Float.pi*2
        }
        
        rotatingObject.transform.rotation = simd_quatf(angle: newRotationValue, axis: SIMD3<Float>(0,1,0))
    }
    
    public mutating func rotationEnded() {
        if let rotatingObject = rotatingObject {
            currentRotationAngle = rotatingObject.transform.rotation.angle
        }
    }
}

