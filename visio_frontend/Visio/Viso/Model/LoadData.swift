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

struct DataPoint: Identifiable{
    var id: String
    var roi_left: Double
    var roi_right: Double
    
    init(id: String, roi_left: Double, roi_right: Double) {
        self.id = id
        self.roi_left = roi_left
        self.roi_right = roi_right
    }
    func date() -> String {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
           let date = Date(timeIntervalSince1970: TimeInterval(Float(id)!))
           return formatter.string(from: date)
       }
}

final class Results: ObservableObject {
    var db = Firestore.firestore()
    @Published var datapoints: [DataPoint] = []
    let collection: String
    let document: String
    let exerciseType: String
    
    private var listenerRegistration: ListenerRegistration?
    
    init(collection: String, document: String, exerciseType: String) {
        self.collection = collection
        self.document = document
        self.exerciseType = exerciseType
        print(self.document)
        print(self.exerciseType)
        loadData()
    }
    
    deinit {
        listenerRegistration?.remove()
    }
    
    private func loadData() {
        let docRef = db.collection(collection).document(document)
        listenerRegistration = docRef.addSnapshotListener { documentSnapshot, error in
            if let documentSnapshot = documentSnapshot, documentSnapshot.exists {
                if let data = documentSnapshot.data(), let exercise_results = data[self.exerciseType] as? [String: [String: Any]] {
                    
                    // reset local data
                    self.datapoints.removeAll()

                    // parse data and store locally
                    for (timestamp, values) in exercise_results {
                        if let left = values["left"] as? Double, let right = values["right"] as? Double {
                            var dp = DataPoint(id:timestamp , roi_left: left, roi_right: right)
                            dp.id = dp.date()
                            self.datapoints.append(dp)
                        }
                    }
                    // sort datapoints based on timestamp
                    self.datapoints.sort(by: { $0.id < $1.id })
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
