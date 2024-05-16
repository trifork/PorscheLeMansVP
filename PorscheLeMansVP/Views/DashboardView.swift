//
//  DashboardView.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 13/05/2024.
//

import SwiftUI

struct DashboardView: View {
    private let gridItemLayout = [GridItem(.fixed(780)), GridItem(.fixed(2000)), GridItem(.fixed(1200))]
    private let gridItemLayoutSpacing = 120.0

    @State private var videoIsReady: Bool = false
    
    @State public var videoViewModel: VideoPlayerViewModel
    @Binding public var isMuted: Bool
    
    var body: some View {
        LazyVGrid(columns: gridItemLayout) {
            VStack {
                HStack {
                    LeaderboardView()
                }
                .frame(width: 780, height: 1200)
                .glassBackgroundEffect()
            }
            .cornerRadius(22)
            .rotation3DEffect(.degrees(20), axis: (x: 0, y: 1, z: 0), anchor: .center)
            .offset(z: 220)
            
            VStack {
                VStack {
                    VideoPlayerView(viewModel: videoViewModel, isMuted: isMuted)
                }
                .frame(width: 2000, height: 1200)
                .glassBackgroundEffect()
            }
            .cornerRadius(22)
            
            HStack(spacing: 20) {
                VStack(spacing: 20) {
                    HStack {
                        SpeedometerView()
                            .padding(80)
                    }
                    .frame(width: 580, height: 580)
                    .modifier(DarkGlasBackgroundEffect())
                    
                    HStack {
                        VStack {
                            IconTextView(icon: Asset.Images.byName("icnBrake"), text: "Brake", alignment: .vertical)
                            ThermometerView(type: .brake, alignment: .left, indicator: "bar")
                        }
                        .padding(20)

                        VStack {
                            IconTextView(icon: Asset.Images.byName("icnThrottle"), text: "Throttle", alignment: .vertical)
                            ThermometerView(type: .throttle, alignment: .right, indicator: "%")
                        }
                        .padding(20)
                    }
                    .frame(width: 580, height: 580)
                    .modifier(DarkGlasBackgroundEffect())
                }
                .frame(width: 580, height: 1200)
                
                VStack {
                    //TickerView()
                    LineChartWrapperView()
                }
                .frame(width: 600, height: 1200)
                .modifier(DarkGlasBackgroundEffect(opacity: 0.3))
            }
            .frame(width: 1200, height: 1200)
            .cornerRadius(22)
            .rotation3DEffect(.degrees(-20), axis: (x: 0, y: 1, z: 0), anchor: .center)
            .offset(z: 220)
        }
        .padding(.horizontal, gridItemLayoutSpacing)
    }
}
