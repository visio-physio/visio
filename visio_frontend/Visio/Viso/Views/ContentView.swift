//
//  ContentView.swift
//  Viso
//
//  Created by person on 2023-01-28.
//

import SwiftUI

struct ContentView: View {
    var body: some View {        
        TabView {
            ExerciseList()
                .tabItem {
                    Label("Exercises", systemImage: "figure.strengthtraining.traditional")
                }
            UserView()
                .tabItem {
                    Label("User", systemImage: "person")
                }
            TestView()
                .tabItem {
                    Label("test", systemImage: "person")
                }
            let url = URL(string: "http://172.20.10.3:8090/")!
            HttpVideoPlayer(url:url)
                .tabItem {
                    Label("test video", systemImage: "person")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
