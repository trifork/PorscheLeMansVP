//
//  VideoPlayerViewModel.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 03/04/2024.
//

import Foundation
import SwiftUI
import CoreMedia

@Observable public final class VideoPlayerViewModel {
    public var videoUrl: URL?
    public var currentTime: CMTime?
    
    init(videoUrl: URL?, currentTime: CMTime? = nil) {
        self.videoUrl = videoUrl
        self.currentTime = currentTime
    }
    
    public func configure(videoUrl: URL?, currentTime: CMTime? = nil) {
        self.videoUrl = videoUrl
        self.currentTime = currentTime
    }
    
    public var availableVideos : [VideoPlayListItem]? {
        [
            VideoPlayListItem(url: URL(string: "https://drlive01hls.akamaized.net/hls/live/2014185/drlive01/master2000.m3u8")!, description: "#1"),
        ]
    }
    
    public var selectedVideo : URL? {
        availableVideos?.first?.url
    }
}
