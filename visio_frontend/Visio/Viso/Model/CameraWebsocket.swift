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
    let server = WebSocketServer()
    @Published var img = Data()
    init(){
        let monitor = NWPathMonitor()
        monitor.start(queue: .main)
        let ip = getIPAddress()
        let port = "8080"
        let url = "http://" + ip + ":" + port + "/"
        var request = URLRequest(url: URL(string: url)!) //https://localhost:8080
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
        print("trying to connect with: \(url)");

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

func getIPAddress() -> String {
    var address: String?

    // Get list of all network interfaces
    var ifaddr: UnsafeMutablePointer<ifaddrs>?
    guard getifaddrs(&ifaddr) == 0 else { return "localhost" }
    defer { freeifaddrs(ifaddr) }

    // Iterate over each network interface
    var pointer = ifaddr
    while pointer != nil {
        let info = pointer!.pointee

        // Get address for the "en0" interface
        if String(cString: info.ifa_name) == "en0", info.ifa_addr.pointee.sa_family == AF_INET {
            var addr = info.ifa_addr.pointee
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
            address = String(cString: hostname)
        }

        pointer = pointer?.pointee.ifa_next
    }

    return address ?? "localhost"
}
