//
//  CameraWebsocket.swift
//  cameraStream
//
//  Created by person on 2023-02-18.
//

import Foundation
import Starscream
import Gzip
import Network

class CameraWebsocket: ObservableObject, WebSocketDelegate {
    var socket: WebSocket!
    var isConnected = false
    var url: String
    @Published var img = Data()

    init(url: String) {
        self.url = url
    }
    func makeConnection() {
        if self.isConnected{
            socket.disconnect()
            self.isConnected = false
        }
        let request = URLRequest(url: URL(string: self.url)!, timeoutInterval: 5)
        self.socket = WebSocket(request: request)
        self.socket.delegate = self
        self.socket.connect()
        self.isConnected = true
        print("Connecting to websocket at: \(self.url)")
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
            let compressedData = Data(base64Encoded: string) ?? Data()
            do {
                img = try compressedData.gunzipped()
            } catch {
                print("Error: \(error)")
            }

            
        case .binary(let data):
            print("got some data: \(data.count) bytes")
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
    
    func connect(){
        socket.write(string: "produce")
    }
    func disconnect(){
        socket.write(string: "end")
    }
    func send(userId: String, bodyPart: String, exercise: String, state: String) {
        let json: [String: Any] = [
            "user_id": userId,
            "body_part": bodyPart,
            "exercise": exercise,
            "state": state
        ]
    
        if let socket = socket {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    socket.write(string: jsonString)
                } else {
                    print("Error converting JSON data to string")
                }
            } catch {
                print("Error creating JSON message: \(error.localizedDescription)")
            }
        } else {
            print("Error: socket is nil")
        }

    }

}
