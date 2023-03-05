import SwiftUI
import Firebase

struct ExerciseDetail: View {
    @EnvironmentObject var modelData: ExerciseResults
    @EnvironmentObject var cam: CameraWebsocket
    @EnvironmentObject var load_exercises: LoadExercises
    @State private var isLiveCameraViewActive = false

    var exercise: Exercise
    let userID = Auth.auth().currentUser?.uid ?? "none"
//    let results = Results(collection: "results", document: "60OZjZbwHEPAEBdXzXoRriqXdcQ2", exerciseType: exercise.bodyPart + "-" + exercise.exercise)
    
    var exerciseIndex: Int {
        load_exercises.exercises.firstIndex(where: { $0.id == exercise.id })!
    }
    
    var chartIndex: Int? {
        return modelData.exerciseHists.firstIndex(where: { $0.id == exercise.id })
    }
    
    
    @State private var isShowVideo = false
    var body: some View {
        NavigationStack{
            let results = Results(collection: "results", document: userID, exerciseType: exercise.exercise + "-" + exercise.bodyPart)

            VStack {
                
                ExerciseRangeOfMotionPlotView()
                    .environmentObject(results)
                if let index = chartIndex {
                    Text("Historical Test Results")
                        .font(.title2)
                        .padding()
                    ExercisePlotView(exerciseHist: modelData.exerciseHists[index])
                }
                HStack {
                    CircleImage(image: exercise.image)
                    VStack (alignment: .leading){
                        HStack {
                            Text(exercise.bodyPart + " " + exercise.exercise)
                                .font(.title2)
                            FavoriteButton(isSet: $load_exercises.exercises[exerciseIndex].isFavorite)

                        }
                        HStack {
                            Text(exercise.measurementField)
                                .font(.subheadline)
                            Spacer()
                            Text(exercise.measurementRange)
                                .font(.subheadline)
                        }
                    }
                }
                Divider()
                Text(exercise.descriptionTitle)
                    .font(.title3)
                Text(exercise.description)
                    .padding()
                
                Button("Start Test") {
                    cam.send(userId: userID, bodyPart: self.exercise.bodyPart, exercise: self.exercise.exercise, state: "start")
                    isLiveCameraViewActive = true
                    print("sending to server: \(self.exercise.exercise)")
                }
                .sheet(isPresented: $isLiveCameraViewActive) {
                        LiveCameraView()
                        }
                Spacer()
            }
        }
        .padding()
    }
}

struct ExerciseDetail_Previews: PreviewProvider {
    static let modelData = ExerciseResults()
//    static let fb = FirebaseDataLoader()
    static let load_data = LoadExercises()
    static var exercise = load_data.exercises[0]

    static var previews: some View {
        ExerciseDetail(exercise: exercise)
            .environmentObject(modelData)
            .environmentObject(load_data)
//            .environmentObject(fb)
    }
}
