import SwiftUI
import FirebaseDatabase

//class FirebaseDataLoader: ObservableObject {
//    @Published var exercises_fb = [ExerciseFB]()
//    
//    init() {
//        
//        let ref = Database.database().reference().child("Exercises")
//        
//        ref.observeSingleEvent(of: .value) { (snapshot, args)  in
//            guard let value = snapshot.value as? [[String: Any]] else {
//                return }
//            for exerciseData in value {
//                let id = exerciseData["id"] as! Int
//                let category = exerciseData["category"] as! String
//                let description = exerciseData["description"] as! String
//                let descriptionTitle = exerciseData["descriptionTitle"] as! String
//                let imageName = exerciseData["imageName"] as! String
//                let isFavorite = exerciseData["isFavorite"] as! Bool
//                let isFeatured = exerciseData["isFeatured"] as! Bool
//                let measurementField = exerciseData["measurementFiled"] as! String
//                let measurementRange = exerciseData["measurementRange"] as! String
//                let test = exerciseData["test"] as! String
//
//                self.exercises_fb.append(ExerciseFB(id: id, category: category, description: description, descriptionTitle: descriptionTitle, imageName: imageName, isFavorite: isFavorite, isFeatured: isFeatured, measurementField: measurementField, measurementRange: measurementRange, test: test))
//            }
//        }
//    }
//}

struct TestView: View {
    @ObservedObject var dataLoader = FirebaseDataLoader()
    
    var body: some View {
        List(dataLoader.exercises_fb) { exercise_fb in
            Text(exercise_fb.test)
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
