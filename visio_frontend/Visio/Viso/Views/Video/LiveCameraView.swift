//
//  LiveCameraView.swift
//  cameraStream
//
//  Created by person on 2023-02-18.
//

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
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .cornerRadius(10.0)
            }
        }
    }
}

struct LiveCameraView_Previews: PreviewProvider {
    static let cam = CameraWebsocket()
    static var previews: some View {
        LiveCameraView()
            .environmentObject(cam)
    }
}
