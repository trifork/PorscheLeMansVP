//
//  LeaderboardView.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 13/05/2024.
//

import SwiftUI

struct LeaderboardView: View {
    
    @State private var updateTimer = Timer.publish(every: 1.01, on: .main, in: .common).autoconnect()
    @State private var leaderboard: [RaceContestantItem] = []
    
    var body: some View {
        VStack {
            List(leaderboard) { item in
                HStack {
                    Text("\(item.position)")
                        .font(Asset.Fonts.porscheRegular(size: 26))
                        .frame(width: 44, height: 44)
                        .background(.white)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                    
                    Color(.red)
                        .frame(width: 4, height: 44)
                    
                    Text(item.initials)
                        .font(Asset.Fonts.porscheBold(size: 26))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text(item.position == 1 ? "Leader" : "+\(String(format: "%.4f", item.time))")
                        .font(Asset.Fonts.porscheBold(size: 26))
                        .foregroundColor(.white)
                }
                .frame(height: 54)
                .listRowBackground(Color.clear)
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
        }
        .onAppear() {
            DataClient.shared.fillLeaderboard() // Prefill data
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name.NSManagedObjectContextObjectsDidChange), perform: { notification in
            leaderboard = DataClient.shared.getLeaderboard()
        })
    }

}
