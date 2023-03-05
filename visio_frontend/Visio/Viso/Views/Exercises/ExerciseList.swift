//
//  ExerciseList.swift
//  Viso
//
//  Created by person on 2023-01-28.
//

import SwiftUI


struct ExerciseList: View {
    
//    @EnvironmentObject var fb_data: FirebaseDataLoader
    @EnvironmentObject var load_exercises: LoadExercises
    @State private var showFavoritesOnly = false
    var camera_socket = CameraWebsocket()
    @State private var url = "https://b898-2607-9880-1aa0-cd-1374-87be-b01b-c4c2.ngrok.io/"

    var filteredExercises: [Exercise] {
        load_exercises.exercises.filter { exercise in
            (!showFavoritesOnly || exercise.isFavorite)
        }
    }
    
    var body: some View {
        
        NavigationStack {
            Button("test"){
                let r = Results(collection: "results", document: "60OZjZbwHEPAEBdXzXoRriqXdcQ2", exerciseType: "abduction-shoulder")
            }
            List {
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Favorites only")
                }
                HStack {
                    Text("URL:")
                    TextField("Enter URL", text: $url)
                    Button("Reconnect"){
                        print("URL: \(url)")
                        camera_socket.url = url
                    }
                }
    
                ForEach(filteredExercises) { exercise in
                    NavigationLink {
                        ExerciseDetail(exercise: exercise).environmentObject(camera_socket)
                    } label: {
                        ExerciseRow(exercise: exercise)
                    }
                }
            }
            .navigationTitle("Exercises")
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
