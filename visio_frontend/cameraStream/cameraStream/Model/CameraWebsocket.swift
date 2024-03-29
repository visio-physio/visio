//
//  CameraWebsocket.swift
//  cameraStream
//
//  Created by person on 2023-02-18.
//

import Foundation
import Starscream

class CameraWebsocket: ObservableObject, WebSocketDelegate {
    var socket: WebSocket!
    var isConnected = false
    let server = WebSocketServer()
    @Published var text = "None"
    @Published var img = Data()

    
    init(){
        var request = URLRequest(url: URL(string: "http://localhost:8080")!) //https://localhost:8080
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
//            print("Received text: \(string)")
            text = string
            
        case .binary(let data):
//            print("Received data: \(data.count)")
            img = data
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            isConnected = false
            handleError(error)
        }
    }
    func handleError(_ error: Error?) {
       if let e = error as? WSError {
           print("websocket encountered an error: \(e.message)")
       } else if let e = error {
           print("websocket encountered an error: \(e.localizedDescription)")
       } else {
           print("websocket encountered an error")
       }
   }
    
    
    func write(){
        socket.write(string: "start")
    }
    
    
    
}
