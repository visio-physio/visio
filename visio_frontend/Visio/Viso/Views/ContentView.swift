import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            LoginView()
        }
        .environment(\.font, .custom("HKGrotesk-Medium", size: 24))
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}

struct ContentView_Previews: PreviewProvider {
    let cam = CameraWebsocket(url:"localhost:8080")
    static var previews: some View {
        ContentView()
            .environmentObject(LoadExercises())
    }
}
