//
//  RaceTrackImmersiveView.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 13/05/2024.
//

import SwiftUI
import RealityKit
import RealityKitContent
import ARKit

struct RaceTrackImmersiveView: View {
    @Environment(\.scenePhase) var scenePhase
    
    @State private var isMuted: Bool = VideoSound.defaultMuted
    @State private var didInitializedSceneEntity: Bool = false
    @State private var videoViewModel = VideoPlayerViewModel(videoUrl: nil)
    @State private var racetrack = Racetrack()
    @State private var moveCarTimer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    
    @State private var dataChanged: Bool = false
    
    private let worldTrackingProvider = WorldTrackingProvider()
    private let arSession = ARKitSession()
    
    private var didAppear: () -> Void
    private var didTapClose: () -> Void
    private var didEnterBackground: () -> Void
    private var didLoadSceneEntity: () -> Void
    
    private var mainContainer = Entity()
    private var racetrackContainer = Entity()
    
    private let trackRotation: Float = 1.48
    private let trackScale: Float = 1/8
    private let trackHorizontalPosition: Float = -0.64
    
    private let platformHeight: Float = 0.005
    private let platformRadius: Float = 0.40
    private let platformContainerScale: Float = 1/11

    private let carsContainer = Entity()
    private let carsPlatform: ModelEntity
    private var carsPlatformIntialDegrees: Float = 135
    @State private var carsRotationHandler = RotatePlatformHandler()
    
    @State private var isCompetitorsVisible: Bool = true
        
    init(didAppear: @escaping () -> Void, didTapClose: @escaping () -> Void, didEnterBackground: @escaping () -> Void, didLoadSceneEntity: @escaping () -> Void) {
        self.mainContainer.position = SIMD3(x: 0.1, y: 1, z: -1.0)

        self.didAppear = didAppear
        self.didTapClose = didTapClose
        self.didEnterBackground = didEnterBackground
        self.didLoadSceneEntity = didLoadSceneEntity
        
        self.carsPlatform = ModelEntity(mesh: .generateCylinder(height: platformHeight / platformContainerScale, radius: platformRadius / platformContainerScale), materials: [Materials.platformMaterial()])
        self.carsPlatform.name = "carsPlatform"
        
        videoViewModel.configure(videoUrl: videoViewModel.selectedVideo)
        
        setupViews()
    }
    
    private func setupViews() {
        // Track and cars
        racetrackContainer.scale *= trackScale
        racetrackContainer.transform.rotation = simd_quatf(angle: trackRotation, axis: SIMD3<Float>(0,1,0))
        racetrackContainer.position = SIMD3(x: trackHorizontalPosition, y: 0.0, z: 0.0)
        mainContainer.addChild(racetrackContainer)
        
        // Cars Platform
        let carsInputComponent = InputTargetComponent(allowedInputTypes: .all)
        carsPlatform.generateCollisionShapes(recursive: true)
        carsPlatform.components.set(carsInputComponent)
        carsPlatform.position = [0.0, 0.0, 0.0]
        carsContainer.addChild(carsPlatform)

        carsContainer.scale *= platformContainerScale
        carsContainer.position = [0.69, -0.01, -0.1]
        mainContainer.addChild(carsContainer)
    }
    
    var body: some View {
        RealityView { content, attachments in
            if let track = try? await racetrack.entity() {
                racetrackContainer.addChild(track)
            }
            
            // Cars
            if let carEntity = try? await Entity(named: "Porsche_963", in: realityKitContentBundle) {
                
                var xScalar: Float = -2.75
                var zScalar: Float = 0.95
                for raceCar in DataClient.shared.getOwnCars() {
                    let car = carEntity.clone(recursive: true)
                    car.name = "DigitalTwin_RaceCar_\(raceCar.carId)"
                    car.position = [carEntity.position.x + xScalar, carEntity.position.y, carEntity.position.z + zScalar]
                    carsContainer.addChild(car)
                    
                    xScalar += 2.75
                    zScalar -= 0.95
                }
                
                // Platform rotation
                carsRotationHandler.configure(rotatingObject: carsContainer, platformSize: platformRadius, initialRotationDegrees: carsPlatformIntialDegrees)
            }
            
            if let dashboard = attachments.entity(for: "Dashboard") {
                dashboard.name = "Dashboard"
                dashboard.position = [0.1, 0.5, -0.8]
                mainContainer.addChild(dashboard)
            }

            if let toolbar = attachments.entity(for: "Toolbar") {
                toolbar.name = "Dashboard"
                toolbar.position = [-0.04, 0.13, -0.4]
                toolbar.transform.rotation = simd_quatf(angle: -0.5, axis: SIMD3<Float>(1,0,0))
                mainContainer.addChild(toolbar)
            }
            
            // Car info
            for raceCar in DataClient.shared.getOwnCars() {
                if let carInfo = attachments.entity(for: "CarInfo_\(raceCar.carId)") {
                    if let carEntity = racetrack.carEntity(by: raceCar.carId), let container = racetrack.carInfoEntity(by: raceCar.carId) {
                        carInfo.name = "CarInfo_\(raceCar.carId)"
                        carInfo.position = [carEntity.position.x, 1.0, carEntity.position.z]
                        carInfo.scale = SIMD3<Float>(repeating: 5)
                        container.addChild(carInfo)
                        
                        let carInfoLine: ModelEntity = LineEntity.lineFrom(carEntity, to: carInfo)
                        container.addChild(carInfoLine)
                    }
                }
            }
            
            content.add(mainContainer)
        } update: { _, attachments in
            Task {
                didInitializedSceneEntity = true
                
                for raceCar in DataClient.shared.getOwnCars() {
                    if let carInfo = attachments.entity(for: "CarInfo_\(raceCar.carId)") {
                        orientEntityTowardsCamera(entity: carInfo)
                    }
                }
            }
        } attachments: {
            Attachment(id: "Dashboard") {
                DashboardView(videoViewModel: videoViewModel, isMuted: $isMuted)
            }
            
            Attachment(id: "Toolbar") {
                ZStack {
                    RaceTrackToolbarView(isMuted: $isMuted, isCompetitorsVisible: $isCompetitorsVisible, didTapClose: {
                        didTapClose()
                    }, didTapShowCompetitor: {
                        isCompetitorsVisible.toggle()
                        racetrack.hideCompetitorCars(visible: isCompetitorsVisible)
                    })
                }
                .offset(z: 131)
            }
            
            ForEach(DataClient.shared.getOwnCars()) { raceCar in
                Attachment(id: "CarInfo_\(raceCar.carId)") {
                    CarInfoView(carId: raceCar.carId, dataChanged: dataChanged, selectedCarId: "6") // TODO: Send in selected car Id
                }
            }
        }
        .task {
            Task {
                try await arSession.run([worldTrackingProvider])
            }
        }
        .gesture(DragGesture(minimumDistance: 5, coordinateSpace: .global)
            .targetedToAnyEntity()
            .onChanged { value in
                if value.entity.name == "carsPlatform" {
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
        .onReceive(moveCarTimer) { _ in
            racetrack.updateCarPosition()
        }
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .background:
                didEnterBackground()
                
            default: break
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name.NSManagedObjectContextObjectsDidChange), perform: { notification in
            dataChanged.toggle()
        })
    }
}

extension RaceTrackImmersiveView {
    private func orientEntityTowardsCamera(entity: Entity) {
        guard let pose = worldTrackingProvider.queryDeviceAnchor(atTimestamp: CACurrentMediaTime()) else { return }
        let cameraTransform = Transform(matrix: pose.originFromAnchorTransform)
        entity.look(at: cameraTransform.translation,
                    from: entity.position(relativeTo: nil),
                    relativeTo: nil,
                    forward: .positiveZ)
    }
}
