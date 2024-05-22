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
    @State private var carCarousel = CarCarousel()
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
    
    @State private var isCompetitorsVisible: Bool = true
        
    init(didAppear: @escaping () -> Void, didTapClose: @escaping () -> Void, didEnterBackground: @escaping () -> Void, didLoadSceneEntity: @escaping () -> Void) {
        self.mainContainer.position = SIMD3(x: 0.1, y: 1, z: -1.0)

        self.didAppear = didAppear
        self.didTapClose = didTapClose
        self.didEnterBackground = didEnterBackground
        self.didLoadSceneEntity = didLoadSceneEntity
        
        videoViewModel.configure(videoUrl: videoViewModel.selectedVideo)
        
        setupViews()
    }
    
    private func setupViews() {
        // Track and cars
        racetrackContainer.scale *= trackScale
        racetrackContainer.transform.rotation = simd_quatf(angle: trackRotation, axis: SIMD3<Float>(0,1,0))
        racetrackContainer.position = SIMD3(x: trackHorizontalPosition, y: 0.0, z: 0.0)
        mainContainer.addChild(racetrackContainer)
    }
    
    var body: some View {
        RealityView { content, attachments in
            // Track with all cars
            if let track = try? await racetrack.entity() {
                racetrackContainer.addChild(track)
            }
            
            // Digital twins on carousel
            if let carouselItems = try? await carCarousel.entity() {
                mainContainer.addChild(carouselItems)
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
                
                carCarousel.preSelectCar()
                
                for raceCar in DataClient.shared.getOwnCars() {
                    if let carInfo = attachments.entity(for: "CarInfo_\(raceCar.carId)") {
                        orientEntityTowardsCamera(entity: carInfo)
                    }
                }
            }
        } attachments: {
            Attachment(id: "Dashboard") {
                DashboardView(videoViewModel: videoViewModel, isMuted: $isMuted, selectedCarId: carCarousel.selectedCarId)
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
                    CarInfoView(carId: raceCar.carId, dataChanged: dataChanged, selectedCarId: carCarousel.selectedCarId) 
                }
            }
        }
        .task {
            Task {
                try await arSession.run([worldTrackingProvider])
            }
        }
        .gesture(
            SpatialTapGesture().targetedToAnyEntity().onEnded({ value in
                let name = value.entity.name
                log(message: "Load data for car name: \(name)", level: .info)
                carCarousel.selectCar(name: name)
            }))
        .gesture(
            DragGesture(minimumDistance: 5, coordinateSpace: .global)
            .targetedToAnyEntity()
            .onChanged { value in
                if value.entity.name == "carsPlatform" {
                    let pointsPerMeter = 1360.0 // Cannot get this from the value, but it can be seen in the debugger
                    carCarousel.updateRotation(startPosition: Float(value.startLocation.x), currentPosition: Float(value.location.x), pointsPerMeter: Float(pointsPerMeter))
                }
            }
            .onEnded { value in
                if value.entity == carCarousel.carsPlatform {
                    carCarousel.rotationEnded()
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
