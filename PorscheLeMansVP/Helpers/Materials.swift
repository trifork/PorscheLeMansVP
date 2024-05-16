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
    
    
}
