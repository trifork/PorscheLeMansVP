//
//  AppMain.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 13/05/2024.
//

import SwiftUI

@main
struct AppMain: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @ObservedObject var webSocketClient = WebSocketClient()
    
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) var dismissWindow
    
    @State private var isLoading: Bool = false
    
    var body: some Scene {
        WindowGroup(id: "WelcomeWindow") {
            VStack {
                WelcomeView(isLoading: isLoading) {
                    isLoading = true
                    
                    Task {
                        DataClient.shared.deleteAll()

                        await NetworkClient.shared.getCars { cars in
                            DataClient.shared.addCars(cars)
                    
                            /*webSocketClient.connect()
                            
                            Task {
                                await openImmersiveSpace(id: "RaceTrackImmersiveView")
                            }*/
                    
                            // Remove after we have a websocket op and running
                            Task {
                                await CSVClient.shared.prefill {
                                    Task {
                                        
                                        webSocketClient.connect()
                                        
                                        await openImmersiveSpace(id: "RaceTrackImmersiveView")
                                    }
                                } failure: { message in
                                    log(message: message, level: .error)
                                    isLoading = false
                                }
                            }
                        } failure: { message in
                            log(message: message, level: .error)
                            isLoading = false
                        }
                        
                    }
                }
                .disabled(isLoading)

            }
            .overlay {
                switch isLoading {
                case true: ProgressView().offset(z: 131)
                default: EmptyView()
                }
            }
        }
        .windowResizability(.contentSize)

        ImmersiveSpace(id: "RaceTrackImmersiveView") {
            RaceTrackImmersiveView(didAppear: {
                log(message: "initializing scene", level: .info)
            }, didTapClose: {
                Task {
                    openWindow(id: "WelcomeWindow")
                    await dismissImmersiveSpace()
                }
            }, didEnterBackground: {
                DataClient.shared.deleteAll()
                webSocketClient.disconnect()
            }, didLoadSceneEntity: {
                isLoading = false
                dismissWindow(id: "WelcomeWindow")
            })
        }
    }
}
