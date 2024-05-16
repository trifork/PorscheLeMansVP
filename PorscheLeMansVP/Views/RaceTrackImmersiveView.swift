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
    @Environment(\.scenePhase) var scenePhase
    
    @State private var isMuted: Bool = VideoSound.defaultMuted
    
    @State private var didInitializedSceneEntity: Bool = false
    @State private var videoViewModel = VideoPlayerViewModel(videoUrl: nil)
    
    private var didAppear: () -> Void
    private var didTapClose: () -> Void
    private var didEnterBackground: () -> Void
    private var didLoadSceneEntity: () -> Void
    
    private var mainContainer = Entity()
    private var trackContainer = Entity()
    
    private let trackRotation: Float = 1.18
    private let trackScale: Float = 1/8
    private let trackHorizontalPosition: Float = 0.12
    
    
    private let platformHeight: Float = 0.005
    private let platformRadius: Float = 0.40
    private let platformContainerScale: Float = 1/11

    private let carsContainer = Entity()
    private let carsPlatform: ModelEntity
    private var carsPlatformIntialDegrees: Float = -135
    @State private var carsRotationHandler = RotatePlatformHandler()
        
    init(didAppear: @escaping () -> Void, didTapClose: @escaping () -> Void, didEnterBackground: @escaping () -> Void, didLoadSceneEntity: @escaping () -> Void) {
        self.mainContainer.position = SIMD3(x: 0.1, y: 1, z: -1.0)

        self.didAppear = didAppear
        self.didTapClose = didTapClose
        self.didEnterBackground = didEnterBackground
        self.didLoadSceneEntity = didLoadSceneEntity
        
        self.carsPlatform = ModelEntity(mesh: .generateCylinder(height: platformHeight / platformContainerScale, radius: platformRadius / platformContainerScale), materials: [Materials.platformMaterial()])
        
        videoViewModel.configure(videoUrl: videoViewModel.selectedVideo)
        
        setupViews()
    }
    
    private func setupViews() {
        // Track
        trackContainer.scale *= trackScale
        trackContainer.transform.rotation = simd_quatf(angle: trackRotation, axis: SIMD3<Float>(0,1,0))
        trackContainer.position = SIMD3(x: trackHorizontalPosition, y: 0.0, z: 0.0)
        mainContainer.addChild(trackContainer)
        
        // Cars Platform
        let carsInputComponent = InputTargetComponent(allowedInputTypes: .all)
        carsPlatform.generateCollisionShapes(recursive: true)
        carsPlatform.components.set(carsInputComponent)
        carsPlatform.position = [0.0, 0.0, 0.0]
        carsContainer.addChild(carsPlatform)

        carsContainer.scale *= platformContainerScale
        carsContainer.position = [-0.55, -0.01, -0.1]
        mainContainer.addChild(carsContainer)
    }
    
    var body: some View {
        RealityView { content, attachments in
            if let track = try? await Entity(named: "LeMansTrack", in: realityKitContentBundle){
                track.name = "TrackEntity"
                trackContainer.addChild(track)
                
                // Cars
                if let carEntity = try? await Entity(named: "Porsche_963", in: realityKitContentBundle) {
                    carEntity.position = [carEntity.position.x, platformHeight / platformContainerScale, carEntity.position.z]
                    carsContainer.addChild(carEntity)
                    
                    let car2 = carEntity.clone(recursive: true)
                    car2.position = [carEntity.position.x - 2.75, carEntity.position.y, carEntity.position.z + 0.95]
                    carsContainer.addChild(car2)
                    
                    let car3 = carEntity.clone(recursive: true)
                    car3.position = [carEntity.position.x + 2.75, carEntity.position.y, carEntity.position.z - 0.95]
                    carsContainer.addChild(car3)
                    
                    
                    // Platform rotation
                    carsRotationHandler.configure(rotatingObject: carsContainer, platformSize: platformRadius, initialRotationDegrees: carsPlatformIntialDegrees)
                }
            }
            
            if let dashboard = attachments.entity(for: "Dashboard") {
                dashboard.name = "Dashboard"
                dashboard.position = [0.1, 0.5, -0.8]
                mainContainer.addChild(dashboard)
            }
            
            content.add(mainContainer)
        } update: { _, attachments in
            Task {
                didInitializedSceneEntity = true
            }
        } attachments: {
            Attachment(id: "Dashboard") {
                DashboardView(videoViewModel: videoViewModel, isMuted: $isMuted)
            }
        }
        .gesture(DragGesture(minimumDistance: 5, coordinateSpace: .global)
            .targetedToAnyEntity()
            .onChanged { value in
                if value.entity == carsPlatform {
                    let pointsPerMeter = 1360.0 // Cannot get this from the value, but it can be seen in the debugger
                    
                    carsRotationHandler.updateRotation(startPosition: Float(value.startLocation.x), currentPosition: Float(value.location.x), pointsPerMeter: Float(pointsPerMeter))
                }
            }
            .onEnded { value in
                if value.entity == carsPlatform {
                    carsRotationHandler.rotationEnded()
                }
                
            }
        )
        .onAppear() {
            didAppear()
        }
        .onChange(of: didInitializedSceneEntity) { oldValue, newValue in
            didLoadSceneEntity()
        }
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .background:
                didEnterBackground()
                
            default: break
            }
        }
    }
}
