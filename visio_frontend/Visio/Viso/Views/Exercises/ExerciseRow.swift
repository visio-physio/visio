//
//  ExerciseRow.swift
//  Viso
//
//  Created by person on 2023-01-28.
//

import SwiftUI

struct ExerciseRow: View {
    var exercise: ExerciseFB
    
    var body: some View {
        HStack {
            exercise.image
                .resizable()
                .frame(width: 50, height: 50)
            Text(exercise.test)
            
            Spacer()

            if exercise.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
    }
}

//struct ExerciseRow_Previews: PreviewProvider {
//    static var exercises = ModelData().exercises
//
//    static var previews: some View {
//        Group {
//            ExerciseRow(exercise: exercises[0])
//            ExerciseRow(exercise: exercises[1])
//        }
//        .previewLayout(.fixed(width: 300, height: 70))
//
//    }
//}
