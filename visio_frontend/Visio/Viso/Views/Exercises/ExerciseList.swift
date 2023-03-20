//
//  ExerciseList.swift
//  Viso
//
//  Created by person on 2023-01-28.
//

import SwiftUI


struct ExerciseList: View {
    @EnvironmentObject var load_exercises: LoadExercises
    @EnvironmentObject var camera_socket: CameraWebsocket

    @State private var showFavoritesOnly = false
    @State private var url = UserDefaults.standard.string(forKey: "url") ?? "https://b898-2607-9880-1aa0-cd-1374-87be-b01b-c4c2.ngrok.io/"

    var filteredExercises: [Exercise] {
        load_exercises.exercises.filter { exercise in
            (!showFavoritesOnly || exercise.isFavorite)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Favorites only")
                }
                HStack {
                    Text("URL:")
                    TextField("Enter URL", text: $url)
                    Button("Connect"){
                        print("URL: \(url)")
                        camera_socket.url = url
                        camera_socket.makeConnection()
                        UserDefaults.standard.set(url, forKey: "url")

                    }
                }
                ForEach(filteredExercises) { exercise in
                    NavigationLink {
                        ExerciseDetail(exercise: exercise)
                    } label: {
                        ExerciseRow(exercise: exercise)
                    }
                }
            }
            .navigationTitle("Exercises")
//            .onAppear {
//                // Connect to camera when the view appears
//                camera_socket.url = url
//                camera_socket.makeConnection()
//            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ExerciseList_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseList()
            .environmentObject(LoadExercises())
    }
}
