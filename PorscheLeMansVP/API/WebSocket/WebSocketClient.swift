//
//  WebSocketClient.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 14/05/2024.
//

import Foundation

class WebSocketClient: ObservableObject {
    private var socket: URLSessionWebSocketTask?
    private let endpoint: Endpoint?
    
    init() { 
        endpoint = WebSocketEndpoint.connect
    }
    
    deinit {
        disconnect()
    }
    
    func connect() {
        guard let endpoint = endpoint else { return }
        
        let request = URLRequest(endpoint: endpoint)
        
        let session = URLSession(configuration: .default)
        socket = session.webSocketTask(with: request)
        socket?.resume()
        
        sendMessage()
        readMessage()
        
        // Setup a ping/pong mechanism to keep the connection alive or detect disconnections.
        setupHeartbeat()
    }
    
    private func setupHeartbeat() {
        // Send a ping at regular intervals
        Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.socket?.sendPing { error in
                if let error = error {
                    log(message: "Ping failed: \(error.localizedDescription)", level: .error)
                    self?.reconnect()
                }
            }
        }
    }
    
    private func reconnect() {
        disconnect()
        connect()
    }
    
    func disconnect() {
        socket?.cancel(with: .goingAway, reason: nil)
        socket = nil
    }
    
    private func sendMessage() {
        let subscriptionMessage: [String: Any] = [
            "type": "subscribe",
            "product_ids": ["BTC-USD", "ETH-USD"],
            "channels": [["name": "ticker", "product_ids": ["BTC-USD", "ETH-USD"]]]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: subscriptionMessage, options: []) else {
            log(message: "Error: Unable to serialize subscription message to JSON", level: .error)
            return
        }
        
        socket?.send(.data(jsonData)) { error in
            if let error = error {
                log(message: "Error in sending message: \(error)", level: .error)
            }
        }
    }
    
    private func readMessage() {
        socket?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                log(message: "Error in receiving message: \(error)", level: .error)
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.handleMessage(text)
                    
                    /*
                    guard let data = value.data(using: .utf8), data.isEmpty == false else { return }
                    log(message: "Received text message", level: .debug)
                    handleSocketData(data)*/
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        self?.handleMessage(text)
                    }
  
                    /*log(message: "Received data message", level: .debug)
                    handleSocketData(data)*/
                default:
                    break
                }
                
                self?.readMessage() // Keep listening
            }
        }
    }
    
    private func handleSocketData(_ data: Data) {
        do {
            let parser = JSONParser<SocketResponse>()
            let socketResponse: SocketResponse = try parser.parse(data: data)
  
            //DataClient.shared.write(socketResponse)
        } catch let error {
            log(message: "Error while parsing data received: \(error)", level: .error)
        }
    }
    
    private func handleMessage(_ text: String) {
        if let data = text.data(using: .utf8) {
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let type = jsonObject["type"] as? String, type == "ticker",
                   let productId = jsonObject["product_id"] as? String,
                   let price = jsonObject["price"] as? String {
                    DispatchQueue.main.async {
                        //log(message: "DATA : \(type) ## \(price) ## \(productId)", level: .error)
                        DataClient.shared.writeTicker(productId: productId, price: price)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    log(message: "Error parsing JSON: \(error)", level: .error)
                }
            }
        }
    }
    
}
