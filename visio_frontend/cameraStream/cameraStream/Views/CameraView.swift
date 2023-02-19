//
//  CameraView.swift
//  cameraStream
//
//  Created by person on 2023-02-18.
//

import SwiftUI

struct CameraView: View {
    @EnvironmentObject var cam: CameraWebsocket
    var body: some View {
        
        VStack{
            Text("Camera View, World!")
            
            LiveCameraView()
            
            Button("Test"){
                cam.write()
            }
            .foregroundColor(.green)
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static let cam = CameraWebsocket()

    static var previews: some View {
        CameraView()
            .environmentObject(cam)
    }
}
