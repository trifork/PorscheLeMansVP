//
//  WelcomeView.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 13/05/2024.
//

import SwiftUI

struct WelcomeView: View {
    @ScaledMetric(relativeTo: .body) private var imageHeightMHP = 21 // default height of body
    @ScaledMetric(relativeTo: .body) private var imageHeightTrifork = 17 // default height of body
    @ScaledMetric(relativeTo: .body) private var imageHeightMirage = 27 // default height of body
    
    var isLoading: Bool
    var onTapNext: () -> Void
    
    var body: some View {
        ZStack(alignment: .center) {
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(LinearGradient(
                        gradient: .init(colors: [Color.clear, Color.black.opacity(0.5)]),
                        startPoint: .init(x: 0.5, y: 0),
                        endPoint: .init(x: 0.5, y: 0.6)
                    ))
                
                HStack(spacing: 0) {
                    Text("Developed by  ")
                        .foregroundColor(.white)
                        .font(Asset.Fonts.porscheRegular(size: 26))
                    
                    Image("MHPLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: imageHeightMHP)
                    
                    Text("  and  ")
                        .foregroundColor(.white)
                        .font(Asset.Fonts.porscheRegular(size: 26))
                    
                    Image("TriforkLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: imageHeightTrifork)
                    
                    Text("  ")
                    
                    Image("MirageInsightsLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: imageHeightMirage)
                }
                .padding()
            }
            
            VStack(alignment: .center) {
                Image("VPAppIcon")
                
                Text(isLoading ? "Please wait..." : "Porsche Race Engineer")
                    .font(Asset.Fonts.porscheBold(size: 48))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(isLoading ? "Loading" : "Virtual")
                    .font(Asset.Fonts.porscheRegular(size: 28))
                    .foregroundColor(.white)
                
                Text(isLoading ? "Preparing track" : "Welcome to the new race engineer workplace")
                    .multilineTextAlignment(.center)
                    .font(Asset.Fonts.porscheThin(size: 26))
                    .foregroundColor(.white)
                
                Spacer().frame(height: 92)
                
                Button(action: {
                    onTapNext()
                }, label: {
                    Text("Let's begin")
                })
                
                Spacer().frame(height: 42)
            }
        }
        .frame(width: 670, height: 880, alignment: .bottom)
        .background {
            Image("WelcomeBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
        
    }
}
