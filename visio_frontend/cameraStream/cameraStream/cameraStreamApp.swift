//
//  cameraStreamApp.swift
//  cameraStream
//
//  Created by person on 2023-02-18.
//

import SwiftUI

@main
struct cameraStreamApp: App {
    @StateObject private var camera_socket = CameraWebsocket()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(camera_socket)
        }
    }
}
