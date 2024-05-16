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
    private let trackHorizontalPosition: Float = -0.32
    
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
        trackContainer.scale *= trackScale
        trackContainer.transform.rotation = simd_quatf(angle: trackRotation, axis: SIMD3<Float>(0,1,0))
        trackContainer.position = SIMD3(x: trackHorizontalPosition, y: 0.0, z: 0.0)
        
        mainContainer.addChild(trackContainer)
    }
    
    var body: some View {
        RealityView { content, attachments in
            if let track = try? await Entity(named: "LeMansTrack", in: realityKitContentBundle){
                track.name = "TrackEntity"
                trackContainer.addChild(track)
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
