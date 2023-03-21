import Foundation
import Combine
import Firebase

final class LoadExercises: ObservableObject {
    @Published var exercises: [Exercise] = load("exercises.json")
}

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

struct SinePoint: Identifiable {
    var left: Double
    var right: Double
    var id: Double
    
    init(left: Double, right: Double, id: Double) {
        self.left = left
        self.right = right
        self.id = id
    }
}

struct DataPoint: Identifiable {
    var id: String
    var roi_left: Double
    var roi_right: Double
    var t_delta: Double
    var t_deltas: [Double]
    var left_timeseries: [Double]
    var right_timeseries: [Double]
    
    init(id: String,roi_left: Double, roi_right: Double, t_delta: Double,t_deltas:[Double], left_timeseries: [Double], right_timeseries: [Double]) {
        self.id = id
        self.roi_left = roi_left
        self.roi_right = roi_right
        self.t_delta = t_delta
        self.t_deltas = t_deltas
        self.left_timeseries = left_timeseries
        self.right_timeseries = right_timeseries
    }
    
    func date() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date(timeIntervalSince1970: TimeInterval(id)!)
        return date
    }
    
    func make_deltas() -> [Double]{
        return (0..<self.left_timeseries.count).map{Double($0) * t_delta}
        
    }
}

final class Results: ObservableObject {
    var db = Firestore.firestore()
    @Published var datapoints: [DataPoint] = []
    @Published var currentData: [SinePoint] = []
    let collection: String
    let document: String
    let exerciseType: String
    
    private var listenerRegistration: ListenerRegistration?
    
    init(collection: String, document: String, exerciseType: String) {
        self.collection = collection
        self.document = document
        self.exerciseType = exerciseType
        self.currentData = []
        loadData()
        print("loading data")
    }
    
    deinit {
        listenerRegistration?.remove()
    }
    
    private func loadData() {
        let docRef = db.collection(collection).document(document)
        
        listenerRegistration = docRef.addSnapshotListener { documentSnapshot, error in
            if let documentSnapshot = documentSnapshot, documentSnapshot.exists {
                if let data = documentSnapshot.data(), let exercise_results = data[self.exerciseType] as? [String: [String: Any]] {
                    self.datapoints.removeAll()
                    //                    print(exercise_results.keys)
                    for (timestamp, values) in exercise_results {
                        if let left = values["max_left"] as? Double, let right = values["max_right"] as? Double,
                           let tDelta = values["delta (s)"] as? Double,
                           let leftSeries = values["left_timestamped"] as? [Double],
                           let rightSeries = values["right_timestamped"] as? [Double] {
                            
                            var dp = DataPoint(id: timestamp, roi_left: left, roi_right: right, t_delta: tDelta, t_deltas: [0.1], left_timeseries: leftSeries, right_timeseries: rightSeries)
                            dp.t_deltas = dp.make_deltas()
                            self.datapoints.append(dp)
                        }
                    }
                    // sort datapoints based on timestamp
                    self.datapoints.sort(by: { $0.id < $1.id })
                    let currentDatapoint = self.datapoints.last ?? DataPoint(id: "", roi_left: 0, roi_right: 0, t_delta: 0, t_deltas: [0], left_timeseries: [0], right_timeseries: [0])
                    let left = currentDatapoint.left_timeseries
                    let right = currentDatapoint.right_timeseries
                    let n = left.count
                    
                    for i in 0..<(n) {
                        self.currentData.append(SinePoint(left: left[i], right: right[i], id: currentDatapoint.t_deltas[i]))
                    }
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
