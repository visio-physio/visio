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
      Database.database().isPersistenceEnabled = false;
    return true
  }
}

@main
struct VisoApp: App {
    @StateObject private var exercise_results = ExerciseResults()
    @StateObject private var fb_data = FirebaseDataLoader()
    @StateObject private var camera_socket = CameraWebsocket()
    @StateObject private var exercises = LoadExercises()

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(exercise_results)
                .environmentObject(fb_data)
                .environmentObject(camera_socket)
                .environmentObject(exercises)
        }
    }
}
