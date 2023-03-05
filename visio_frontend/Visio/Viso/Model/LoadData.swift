import Foundation
import Combine
import Firebase

final class LoadExercises: ObservableObject {
    @Published var exercises: [Exercise] = load("exercises.json")
}

//final class ExerciseResults: ObservableObject {
//    var exerciseHists: [ExerciseResult] = load("exerciseResults.json")
//}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}




final class ExerciseResults: ObservableObject {
    var exerciseHists: [ExerciseResult] = load("exerciseResults.json")
}

func load2<T: Decodable>(_ data: Data) -> T {
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse data \(T.self):\n\(error)")
    }
}



//final class Results: ObservableObject {
//    let db = Firestore.firestore()
//    var data = Data()
//    func loadResults(collection: String, document: String, exerciseType: String) {
//        let docRef = db.collection(collection).document(document)
//
//        docRef.getDocument { (documentSnapshot, error) in
//            if let documentSnapshot = documentSnapshot, documentSnapshot.exists {
//                if let data = documentSnapshot.data(){
//                    if let exercise_results = data["abduction-shoulder"] {
//
//                        print(exercise_results)
//                        //add code here chat gpt
//                    }
//                }
//                else{
//                    print("no data was found")
//                }
//            } else {
//                print("Document does not exist")
//            }
//        }
//    }
//}
//
//

struct Datapoint: Identifiable{
    var id: String
    var roi_left: Double
    var roi_right: Double
    
    init(id: String, roi_left: Double, roi_right: Double) {
        self.id = id
        self.roi_left = roi_left
        self.roi_right = roi_right
    }
}

final class Results: ObservableObject {
    let db = Firestore.firestore()
    @Published var leftValues: [Double] = []
    @Published var rightValues: [Double] = []
    @Published var timestamps: [Double] = []
    @Published var datapoints: [Datapoint] = []
    let collection: String
    let document: String
    let exerciseType: String
    init(collection: String, document: String, exerciseType: String) {
        self.collection = collection
        self.document = document
        self.exerciseType = exerciseType
        
        let docRef = db.collection(collection).document(document)
        docRef.getDocument { (documentSnapshot, error) in
            if let documentSnapshot = documentSnapshot, documentSnapshot.exists {
                if let data = documentSnapshot.data(), let exercise_results = data[self.exerciseType] as? [String: [String: Any]] {

                    // parse data and store locally
                    for (timestamp, values) in exercise_results {
                        if let left = values["left"] as? Double, let right = values["right"] as? Double {
                            self.leftValues.append(left)
                            self.rightValues.append(right)
                            self.timestamps.append(Double(timestamp) ?? 0.0)
                            self.datapoints.append(Datapoint(id:timestamp , roi_left: left, roi_right: right))
                        }
                    }

                    // save locally using User Defaults
//                    let defaults = UserDefaults.standard
//                    defaults.set(self.leftValues, forKey: "leftValues")
//                    defaults.set(self.rightValues, forKey: "rightValues")
//                    defaults.set(self.timestamps, forKey: "timestamps")
                    
                    print(self.leftValues)
                    print(self.rightValues)
                    print(self.timestamps)
                }
                else {
                    print("No data was found")
                }
            } else {
                print("Document does not exist")
            }
        }
    }


}
