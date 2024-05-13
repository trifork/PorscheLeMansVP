//
//  VideoPlayerView.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 03/04/2024.
//

import SwiftUI
import RealityKit
import RealityKitContent
import AVFoundation
import ARKit

struct VideoPlayerView: View {
    @Environment(\.physicalMetrics) private var metricsConverter: PhysicalMetricsConverter
    
    let viewModel: VideoPlayerViewModel
    let isMuted: Bool
    let isPlaying: Bool
    
    @State private var player: AVPlayer!
    @State private var statusObserver: NSKeyValueObservation?
    
    var body: some View {
        GeometryReader3D { proxy in
            let sizeInMeters = metricsConverter.convert(proxy.size, to: .meters)
            
            RealityView() { content in
                 //Create Entity for the video
                let videoEntity = Entity()
                
                //Search for video in paths
                guard let url = viewModel.videoUrl else {fatalError("Video was not found!")}
                
                //create a simple AVPlayer
                let asset = AVURLAsset(url: url)
                let playerItem = AVPlayerItem(asset: asset)
                playerItem.preferredForwardBufferDuration = 20
                
                player = AVPlayer()
                
                //create a videoMaterial
                let material = VideoMaterial(avPlayer: player)
            
                //Made a Sphere with the videoEntity and asign the videoMaterial to it
                videoEntity.components.set(
                    ModelComponent(mesh: .generateBox(width: Float(sizeInMeters.width), height: Float(sizeInMeters.height), depth: 0.05, cornerRadius: 0.22), materials: [material])
                )
                
                //add VideoEntity to realityView
                content.add(videoEntity)
                
                // start the VideoPlayer
                player.replaceCurrentItem(with: playerItem)
                player.isMuted = isMuted
                player.automaticallyWaitsToMinimizeStalling = false
                
                player.audiovisualBackgroundPlaybackPolicy = .continuesIfPossible
                
                // Video state observer
                statusObserver = player.currentItem?.observe(\.status, options:  [.new, .old], changeHandler: { item, _ in
                    if item.status == .readyToPlay {
                        // did Change Status To Ready
                        play()
                    }
                })
            }
        }
        //.modifier(DarkGlasBackgroundEffect())
        .onChange(of: isMuted) {
            mute()
        }
        .onChange(of: isPlaying) {
            play()
        }
        .onChange(of: viewModel.videoUrl) {
            let item = viewModel.videoUrl.map {
                let asset = AVURLAsset(url: $0)
                return AVPlayerItem(asset: asset)
            }
            player.replaceCurrentItem(with: item)
            
            if let currentTime = viewModel.currentTime, currentTime.isValid {
                player.seek(to: currentTime) { ready in
                    play()
                }                
                viewModel.currentTime = nil
            }
        }     
    }

    private func mute() {
        player.isMuted = isMuted
    }
    
    private func play() {
        if isPlaying {
            player.play()
        } else {
            player.pause()
        }
    }
}
