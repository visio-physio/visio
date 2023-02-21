//
//  VisoApp.swift
//  Viso
//
//  Created by person on 2023-01-28.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseDatabase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
      Database.database().isPersistenceEnabled = true;
    return true
  }
}

@main
struct VisoApp: App {
    @StateObject private var modelData = ModelData()
    @StateObject private var fb_data = FirebaseDataLoader()
    @StateObject private var camera_socket = CameraWebsocket()

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
                .environmentObject(fb_data)
                .environmentObject(camera_socket)
        }
    }
}
