//
//  ContentView.swift
//  cameraStream
//
//  Created by person on 2023-02-18.
//

import SwiftUI
import Starscream

struct ContentView: View {
    var body: some View {
        VStack {
            CameraView()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
