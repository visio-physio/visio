//
//  ExerciseList.swift
//  Viso
//
//  Created by person on 2023-01-28.
//

import SwiftUI

struct ExerciseList: View {
//    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var fb_data: FirebaseDataLoader
    @State private var showFavoritesOnly = false
    
    var filteredExercises: [ExerciseFB] {
        fb_data.exercises_fb.filter { exercise in
            (!showFavoritesOnly || exercise.isFavorite)
        }
    }
    
    
    var body: some View {
        NavigationView {
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
    }
}

struct ExerciseList_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseList()
            .environmentObject(FirebaseDataLoader())
            
    }
}
