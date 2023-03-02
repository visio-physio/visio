//
//  FirebaseData.swift
//  Viso
//
//  Created by person on 2023-02-06.
//

import Foundation
import FirebaseDatabase
import Firebase

final class FirebaseDataLoader: ObservableObject {
    @Published var exercises_fb = [ExerciseFB]()

    init() {
        
        let ref = Database.database().reference().child("Exercises")
        ref.observeSingleEvent(of: .value) { (snapshot, args)  in
            guard let value = snapshot.value as? [[String: Any]] else {
                return }
            for exerciseData in value {
                let id = exerciseData["id"] as! Int
                let category = exerciseData["category"] as! String
                let description = exerciseData["description"] as! String
                let descriptionTitle = exerciseData["descriptionTitle"] as! String
                let imageName = exerciseData["imageName"] as! String
                let isFavorite = exerciseData["isFavorite"] as! Bool
                let isFeatured = exerciseData["isFeatured"] as! Bool
                let measurementField = exerciseData["measurementField"] as? String ?? "none"
//                let measurementField = exerciseData["measurementField"] as! String :["none"]
                let measurementRange = exerciseData["measurementRange"] as! String
                let test = exerciseData["test"] as! String

                self.exercises_fb.append(ExerciseFB(id: id, category: category, description: description, descriptionTitle: descriptionTitle, imageName: imageName, isFavorite: isFavorite, isFeatured: isFeatured, measurementField: measurementField, measurementRange: measurementRange, test: test))
            }
        }
    }
}
