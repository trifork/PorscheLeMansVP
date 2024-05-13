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
    @State private var isMuted: Bool = VideoSound.defaultMuted
    
    @State private var didInitializedSceneEntity: Bool = false
    @State private var videoViewModel = VideoPlayerViewModel(videoUrl: nil)
    
    private var didAppear: () -> Void
    private var didTapClose: () -> Void
    private var didLoadSceneEntity: () -> Void
    
    private var mainContainer = Entity()
    private var trackContainer = Entity()
    
    private let trackRotation: Float = 1.18
    private let trackScale: Float = 1/8
    private let trackHorizontalPosition: Float = -0.35
    
    init(didAppear: @escaping () -> Void, didTapClose: @escaping () -> Void, didLoadSceneEntity: @escaping () -> Void) {
        self.mainContainer.position = SIMD3(x: 0, y: 1, z: -1.0)

        self.didAppear = didAppear
        self.didTapClose = didTapClose
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
                DataGridView(videoViewModel: videoViewModel, isMuted: $isMuted)
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
