import SwiftUI

struct ContentView: View {
    var body: some View {
        LoginView()
    }
}

struct ContentView_Previews: PreviewProvider {
    let cam = CameraWebsocket(url:"localhost:8080")
    static var previews: some View {
        ContentView()
            .environmentObject(LoadExercises())
    }
}
