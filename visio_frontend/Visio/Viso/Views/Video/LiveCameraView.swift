import SwiftUI
import FirebaseAuth

struct LiveCameraView: View {
    @EnvironmentObject var cam: CameraWebsocket
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack{
                if let image = UIImage(data: cam.img) {
                    Image(uiImage: image)
                      .resizable()
                      .scaledToFit()
                } else {
                    Text("Livestream is not connected!")
                }
                
                Button("End Examination"){
                    let userID = Auth.auth().currentUser?.uid ?? "none"
                    
                    cam.send(userId: userID, bodyPart: "String", exercise: "String", state: "end")
                    dismiss()
                }
                .buttonStyle(BlueButton())
            }
        }
        .backgroundStyle()
        .navigationBarBackButtonHidden(true)
    }
}

struct LiveCameraView_Previews: PreviewProvider {
    static let cam = CameraWebsocket(url:"localhost:8080")
    static var previews: some View {
        LiveCameraView()
            .environmentObject(cam)
    }
}
