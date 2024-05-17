//
//  RaceTrackToolbarView.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 17/05/2024.
//

import SwiftUI

struct RaceTrackToolbarView: View {
    @Binding var isMuted: Bool
    @Binding var isCompetitorsVisible: Bool
    
    var didTapClose: () -> Void
    var didTapShowCompetitor: () -> Void
    
    var body: some View {
        VStack {
            
            HStack {
                Button(action: {
                    didTapShowCompetitor()
                }, label: {
                    Image(systemName: isCompetitorsVisible == true ? "eye.slash" : "eye")
                        .contentShape(Rectangle())
                    Text(isCompetitorsVisible == true ? "Hide competitors" : "Show competitors")
                })
                
                Spacer().frame(width: 90)
                
                Button(action: {
                    isMuted.toggle()
                }, label: {
                    Image(systemName: isMuted == true ? "speaker.slash" : "speaker.wave.3.fill")
                        .contentShape(Rectangle())
                })
                
                Button(action: {
                    didTapClose()
                }, label: {
                    Image(systemName: "xmark")
                        .contentShape(Rectangle())
                })
            }
            .padding(EdgeInsets(top: 18, leading: 32, bottom: 18, trailing: 32))
        }
        .modifier(DarkGlasBackgroundEffect())
    }
}
