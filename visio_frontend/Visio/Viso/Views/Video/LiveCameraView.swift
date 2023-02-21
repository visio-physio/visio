//
//  LiveCameraView.swift
//  cameraStream
//
//  Created by person on 2023-02-18.
//

import SwiftUI

struct LiveCameraView: View {
    @EnvironmentObject var cam: CameraWebsocket
   
    var body: some View {
        
        VStack{
        
            Button("Disconnect"){
                cam.disconnect()
            }
            let data = Data(base64Encoded: cam.text) ?? cam.img
            if let image = UIImage(data: data) {
                Image(uiImage: image)
                  .resizable()
                  .scaledToFit()
            } else {
                Text("Invalid image data")
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
