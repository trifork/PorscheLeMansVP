//
//  DashboardView.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 13/05/2024.
//

import SwiftUI

struct DashboardView: View {
    private let gridItemLayout = [GridItem(.fixed(780)), GridItem(.fixed(2000)), GridItem(.fixed(780))]
    private let gridItemLayoutSpacing = 120.0

    @State private var videoIsReady: Bool = false
    
    @State public var videoViewModel: VideoPlayerViewModel
    @Binding public var isMuted: Bool
    
    var body: some View {
        LazyVGrid(columns: gridItemLayout) {
            VStack(spacing: gridItemLayoutSpacing) {
                HStack {
                    LeaderboardView()
                }
                .frame(width: 780, height: 1200)
                .glassBackgroundEffect()
            }
            .cornerRadius(22)
            .rotation3DEffect(.degrees(20), axis: (x: 0, y: 1, z: 0), anchor: .center)
            .offset(z: 220)
            
            VStack(spacing: gridItemLayoutSpacing) {
                VStack(spacing: gridItemLayoutSpacing) {
                    VideoPlayerView(viewModel: videoViewModel, isMuted: isMuted)
                }
                .frame(width: 2000, height: 1200)
                .glassBackgroundEffect()
            }
            .cornerRadius(22)
            
            VStack(spacing: gridItemLayoutSpacing) {
                VStack {
                    TickerView()
                }
                .frame(width: 780, height: 1200)
                .glassBackgroundEffect()
            }
            .cornerRadius(22)
            .rotation3DEffect(.degrees(-20), axis: (x: 0, y: 1, z: 0), anchor: .center)
            .offset(z: 220)
        }
        .padding(.horizontal, gridItemLayoutSpacing)
    }
}
