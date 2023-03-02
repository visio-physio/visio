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
                ForEach(filteredExercises) { exercise in
                    NavigationLink {
                        ExerciseDetail(exercise: exercise)
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
