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

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct VisoApp: App {
    @StateObject private var modelData = ModelData()
    @StateObject private var fb_data = FirebaseDataLoader()
    @StateObject private var client = VisioClient(host: "127.0.0.1", port: 8888, delegate: nil)

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
                .environmentObject(fb_data)
                .environmentObject(client)
        }
    }
}
