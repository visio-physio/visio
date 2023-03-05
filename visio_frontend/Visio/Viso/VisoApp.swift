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
    @StateObject private var exercises = LoadExercises()
    let cam  = CameraWebsocket(url:"localhost:8080")

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(exercise_results)
                .environmentObject(exercises)
                .environmentObject(cam)
        }
    }
}
