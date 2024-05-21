//
//  LeaderboardView.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 13/05/2024.
//

import SwiftUI
import SwiftData
import CoreData

struct LeaderboardView: View {
    
    @State private var updateTimer = Timer.publish(every: 2.01, on: .main, in: .common).autoconnect()
    @State private var leaderboard: [RaceContestantItem] = []
    
    public var selectedCarId: String
    
    var body: some View {
        VStack {
            List(Array(leaderboard.enumerated()), id: \.1.index) { index, item in
                HStack {
                    Text("\(index + 1)")
                        .font(Asset.Fonts.porscheRegular(size: 26))
                        .frame(width: 44, height: 44)
                        .background(.white)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                    
                    Spacer().frame(width: 20)
                    
                    Asset.Images.byName("icnFlag_\(item.country)")
                        .frame(alignment: .leading)
                    
                    Spacer().frame(width: 20)
                    
                    Color(hex: "\(item.color)")
                        .frame(width: 8, height: 44)
                    
                    Spacer().frame(width: 20)
                    
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(Asset.Fonts.porscheBold(size: 26))
                            .foregroundColor(.white)
                            .frame(alignment: .leading)
                        Text(item.carType)
                            .font(Asset.Fonts.porscheRegular(size: 20))
                            .foregroundColor(.gray)
                            .frame(alignment: .leading)
                    }
                    
                    Spacer()
                    
                    Text(item.position == 1 ? "Leader" : "+\(String(format: "%.4f", item.time))")
                        .font(Asset.Fonts.porscheBold(size: 26))
                        .foregroundColor(.white)
                }
                .frame(height: 54)
                .listRowBackground((selectedCarId == item.carId) ? Color.glassBlue : Color.clear)
            }
            .listRowSeparator(.hidden, edges: .all)
            .listRowBackground(Color.clear)
            .scrollContentBackground(.hidden)
            .padding(EdgeInsets(top: 28, leading: 8, bottom: 28, trailing: 8))
            .animation(.default)
        }
        .onReceive(updateTimer) { _ in
            DataClient.shared.updateLeaderboard(for: 2)
            DataClient.shared.updateLeaderboard(for: 3)
            DataClient.shared.updateLeaderboard(for: 6)
            DataClient.shared.updateLeaderboard(for: 11)
        }
        .onAppear() {
            DataClient.shared.fillLeaderboard() // Prefill data
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name.NSManagedObjectContextObjectsDidChange), perform: { notification in
            if DataClient.shared.isModified(of: RaceContestantItem.self, notification: notification) {
                leaderboard = DataClient.shared.getLeaderboard()
            }
        })
        .modifier(DarkGlasBackgroundEffect())
        .padding(20)
    }

}
