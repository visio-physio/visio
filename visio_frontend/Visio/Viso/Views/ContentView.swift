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
            LoginView()
                .tabItem {
                    Label("Login", systemImage: "figure.strengthtraining.traditional")
                }
            
            ExerciseList()
                .tabItem {
                    Label("Exercises", systemImage: "figure.strengthtraining.traditional")
                }
            UserView()
                .tabItem {
                    Label("User", systemImage: "person")
                }
            SettingsView()
                .tabItem {
                    Label("User", systemImage: "person")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(FirebaseDataLoader())
    }
}
