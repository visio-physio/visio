//
//  LiveCameraView.swift
//  cameraStream
//
//  Created by person on 2023-02-18.
//

import SwiftUI
//
//struct LiveCameraView: View {
//    @EnvironmentObject var cam: CameraWebsocket
//
//    var body: some View {
//        VStack{
//            Text(cam.text)
//
//            Text(String(cam.img.count))
//
//            Image(uiImage: UIImage(data: cam.img) ?? UIImage())
//              .resizable()
//              .scaledToFit()
//
//        }
//    }
//}


struct LiveCameraView: View {
    @EnvironmentObject var cam: CameraWebsocket

    var body: some View {
        VStack{
            Text(String(cam.text.count))
            
            Text(String(cam.img.count))
            
            let data = Data(base64Encoded: cam.text) ?? cam.img

            
            if let image = UIImage(data: data) {
                Image(uiImage: image)
                  .resizable()
                  .scaledToFit()
            } else {
                Text("Invalid image data")
            }
        }
//        .onReceive(cam.$img) { data in
//            if data.isEmpty {
//                print("Received empty image data")
//            } else {
//                print("Received image data of size \(data.count)")
//            }
//        }
    }
}



struct LiveCameraView_Previews: PreviewProvider {
    static let cam = CameraWebsocket()
    static var previews: some View {
        LiveCameraView()
            .environmentObject(cam)
    }
}
