//
//  VisioClient.swift
//  Viso
//
//  Created by Vector Wu on 2023-02-10.
//

import Foundation
import Network

final class VisioClient: ObservableObject{
    let connection: ClientConnection
    let host: NWEndpoint.Host
    let port: NWEndpoint.Port

    init(host: String, port: UInt16, delegate: PoseLiveFeedDelegate?) {
        self.host = NWEndpoint.Host(host)
        self.port = NWEndpoint.Port(rawValue: port)!
        let nwConnection = NWConnection(host: self.host, port: self.port, using: .tcp)
        connection = ClientConnection(nwConnection: nwConnection, delegate: delegate)
    }

    func start() -> String{
        print("Client started \(host) \(port)")
//        connection.didStopCallback = didStopCallback(error:)
//        connection.start()
        return "client started"
    }

    func stop() {
        connection.stop()
    }

    func send(data: Data) {
        connection.send(data: data)
    }

    func didStopCallback(error: Error?) {
        if error == nil {
            exit(EXIT_SUCCESS)
        } else {
            exit(EXIT_FAILURE)
        }
    }
}

