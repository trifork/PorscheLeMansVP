//
//  TickerView.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 14/05/2024.
//

import Foundation
import SwiftUI

struct TickerView: View {
    
    @State private var tickers: [TickerItem] = []
    
    var body: some View {
        VStack {
            List(tickers) { item in
                HStack {
                    Text(item.productId)
                        .font(Asset.Fonts.porscheBold(size: 26))
                        .foregroundColor(.white)

                    Spacer()
                    
                    Text(item.price)
                        .font(Asset.Fonts.porscheBold(size: 42))
                        .foregroundColor(.white)
                }
                .frame(height: 54)
                .listRowBackground(Color.clear)
            }
            .listRowSeparator(.hidden, edges: .all)
            .listRowBackground(Color.clear)
            .scrollContentBackground(.hidden)
            .padding(EdgeInsets(top: 28, leading: 8, bottom: 28, trailing: 8))
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name.NSManagedObjectContextObjectsDidChange), perform: { notification in
            if DataClient.shared.isModified(of: TickerItem.self, notification: notification) {
                tickers = DataClient.shared.getTickers()
            }
        })
    }

}
