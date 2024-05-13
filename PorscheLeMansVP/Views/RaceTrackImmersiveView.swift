//
//  RaceTrackImmersiveView.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 13/05/2024.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct RaceTrackImmersiveView: View {
    @Binding private var isPlaying: Bool
    @Binding private var isMuted: Bool
    
    @State private var didInitializedSceneEntity: Bool = false
    
    private var didAppear: () -> Void
    private var didTapClose: () -> Void
    private var didLoadSceneEntity: () -> Void
    
    private var mainContainer = Entity()
    private let racetrackContainer = Entity()
    private let racetrackPlatform: ModelEntity
    
    private let platformHeight: Float = 0.005
    private let platformRadius: Float = 0.40
    private let platformContainerScale: Float = 1/11
    private let platformHorizontalHeightLocation: Float = -0.05
    
    init(isPlaying: Binding<Bool>, isMuted: Binding<Bool>, didAppear: @escaping () -> Void, didTapClose: @escaping () -> Void, didLoadSceneEntity: @escaping () -> Void) {
        self.mainContainer.position = SIMD3(x: 0, y: 1, z: -1.0)
        
        self.racetrackPlatform = ModelEntity(mesh: .generateCylinder(height: platformHeight / platformContainerScale, radius: platformRadius / platformContainerScale), materials: [])
        
        self._isPlaying = isPlaying
        self._isMuted = isMuted
        self.didAppear = didAppear
        self.didTapClose = didTapClose
        self.didLoadSceneEntity = didLoadSceneEntity
        
        setupViews()
    }
    
    private func setupViews() {
        // Yacht Platform
        let inputComponent = InputTargetComponent(allowedInputTypes: .all)
        racetrackPlatform.generateCollisionShapes(recursive: true)
        racetrackPlatform.components.set(inputComponent)
        racetrackPlatform.position = [0.0, -0.9, -2.0]
        
        racetrackContainer.scale *= platformContainerScale
        racetrackContainer.position = [-0.80, platformHorizontalHeightLocation, 0.0]
        racetrackContainer.addChild(racetrackPlatform)
        mainContainer.addChild(racetrackContainer)
    }
    
    
    var body: some View {
        RealityView { content, attachments in
            // Race track scene
            
            if let scene = try? await Entity(named: "Scene", in: realityKitContentBundle){
                scene.name = "Scene"
                scene.position = [racetrackPlatform.position.x, racetrackPlatform.position.y - 0.8, racetrackPlatform.position.z]
                scene.scale = .init(repeating: 10)
                scene.transform.rotation = simd_quatf(angle: Float(Angle.degrees(-90).radians), axis: SIMD3<Float>(0, 1, 0))
                racetrackContainer.addChild(scene)
                
            }
            
            if let grid = attachments.entity(for: "DataGrid") {
                grid.name = "DataGrid"
                grid.position = [0.0, 0.5, -0.8]
                mainContainer.addChild(grid)
            }
            
            content.add(mainContainer)
        } update: { _, attachments in
            Task {
                didInitializedSceneEntity = true
            }
        } attachments: {
            Attachment(id: "DataGrid") {
                Text("asdasdæljkas ldkas ædlkasædk")
            }
        }
        .onAppear() {
            didAppear()
        }
        .onChange(of: didInitializedSceneEntity) { oldValue, newValue in
            didLoadSceneEntity()
        }
    }
}
