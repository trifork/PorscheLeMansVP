//
//  Materials.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 13/05/2024.
//

import Foundation
import RealityKit

class Materials {
    public static func clearMaterial() -> PhysicallyBasedMaterial {
        var material = PhysicallyBasedMaterial()
        material.baseColor = PhysicallyBasedMaterial.BaseColor(tint: .clear)
        material.roughness = PhysicallyBasedMaterial.Roughness(floatLiteral: 0.0)
        material.metallic =  PhysicallyBasedMaterial.Metallic(floatLiteral: 0.0)
        material.blending = .transparent(opacity: 0.0)
        material.sheen = .init(tint: .clear)
        
        return material
    }
    
    public static func platformMaterial() -> PhysicallyBasedMaterial {
        var material = PhysicallyBasedMaterial()
        material.baseColor = PhysicallyBasedMaterial.BaseColor(tint: .darkGray)
        material.roughness = PhysicallyBasedMaterial.Roughness(floatLiteral: 0.6)
        material.metallic = PhysicallyBasedMaterial.Metallic(floatLiteral: 1.0)
        material.blending = .transparent(opacity: .init(floatLiteral: 0.9))
        let sheenColor = PhysicallyBasedMaterial.Color(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        material.sheen = .init(tint: sheenColor)
        
        return material
    }
    
}
