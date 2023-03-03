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
      var url: String {
          didSet {
              // Reconnect the socket when the URL changes
              reconnect()
          }
      }
      @Published var img = Data()
      
      init(url: String = "https://b898-2607-9880-1aa0-cd-1374-87be-b01b-c4c2.ngrok.io/") {
          self.url = url
          let request = URLRequest(url: URL(string: self.url)!, timeoutInterval: 5)
          socket = WebSocket(request: request)
          socket.delegate = self
          socket.connect()
          print("Connecting to websocket at: \(self.url)")
      }
      
      func reconnect() {
          socket.disconnect()
          let request = URLRequest(url: URL(string: self.url)!, timeoutInterval: 5)
          socket = WebSocket(request: request)
          socket.delegate = self
          socket.connect()
          print("Reconnecting to websocket at: \(self.url)")
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
    func send(exerciseName:String){
        socket.write(string: exerciseName)
    }
}
