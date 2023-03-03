import Foundation
import Combine
import Firebase

final class LoadExercises: ObservableObject {
    @Published var exercises: [Exercise] = load("exercises.json")
}

final class ExerciseResults: ObservableObject {
    var exerciseHists: [ExerciseHist] = load("exerciseResults.json")
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



final class Results: ObservableObject {
    let db = Firestore.firestore()
    
    func loadResults(){
        db.collection(K.FStore.results)
            .addSnapshotListener { querySnapshot, error in
                if let e = error{
                    print("Error connecting to Firestore \(K.FStore.results). \(e)")
                } else{
                    print("Connected to Firestore \(K.FStore.results).")
                    if let snapshotDocument = querySnapshot?.documents {
                        print("snapshotDocument")
                        print(snapshotDocument)
                        for doc in snapshotDocument {
                            let data = doc.data()
                            print(data)
                        }
                    }
                }
            }
    }
    
    func write(){
        let citiesRef = db.collection("cities")

        citiesRef.document("SF").setData([
            "name": "San Francisco",
            "state": "CA",
            "country": "USA",
            "capital": false,
            "population": 860000,
            "regions": ["west_coast", "norcal"]
            ])
        citiesRef.document("LA").setData([
            "name": "Los Angeles",
            "state": "CA",
            "country": "USA",
            "capital": false,
            "population": 3900000,
            "regions": ["west_coast", "socal"]
            ])
        citiesRef.document("DC").setData([
            "name": "Washington D.C.",
            "country": "USA",
            "capital": true,
            "population": 680000,
            "regions": ["east_coast"]
            ])
        citiesRef.document("TOK").setData([
            "name": "Tokyo",
            "country": "Japan",
            "capital": true,
            "population": 9000000,
            "regions": ["kanto", "honshu"]
            ])
        citiesRef.document("BJ").setData([
            "name": "Beijing",
            "country": "China",
            "capital": true,
            "population": 21500000,
            "regions": ["jingjinji", "hebei"]
            ])
    }
    func read(){
        let docRef = db.collection("cities").document("SF")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
    }
}
