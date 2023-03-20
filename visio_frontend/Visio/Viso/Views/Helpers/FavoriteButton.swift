/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A button that acts as a favorites indicator.
*/

import SwiftUI

struct FavoriteButton: View {
    @Binding var isSet: Bool
    @EnvironmentObject var load_exercises: LoadExercises
    var exercise_id : Int
    var body: some View {
        Button {
            isSet.toggle()
            toggleFavorite()
        } label: {
            Label("Toggle Favorite", systemImage: isSet ? "star.fill" : "star")
                .labelStyle(.iconOnly)
                .foregroundColor(isSet ? .yellow : .gray)
        }
    }
    
    func toggleFavorite() {
        if let index = load_exercises.exercises.firstIndex(where: { $0.id == exercise_id }) {
            load_exercises.exercises[index].isFavorite.toggle()
            UserDefaults.standard.set(try? JSONEncoder().encode(load_exercises.exercises), forKey: "exercises")
        }
    }
}

//
//struct FavoriteButton_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoriteButton(isSet: .constant(true))
//    }
//}
