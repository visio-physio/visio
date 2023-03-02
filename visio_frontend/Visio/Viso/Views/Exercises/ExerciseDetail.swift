import SwiftUI

struct ExerciseDetail: View {
    @EnvironmentObject var modelData: ExerciseResults
//    @EnvironmentObject var fb_data: FirebaseDataLoader
    @EnvironmentObject var cam: CameraWebsocket
    @EnvironmentObject var load_exercises: LoadExercises
    @State private var isLiveCameraViewActive = false

    var exercise: Exercise
    
    var exerciseIndex: Int {
        load_exercises.exercises.firstIndex(where: { $0.id == exercise.id })!
    }
    
    var chartIndex: Int? {
        return modelData.exerciseHists.firstIndex(where: { $0.id == exercise.id })
    }
    @State private var isShowVideo = false

    var body: some View {
        VStack {
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
                        Text(exercise.exercise_name)
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
                cam.send(exerciseName: self.exercise.exercise_name)
                isLiveCameraViewActive = true
            }
            NavigationLink(destination: LiveCameraView(),
                isActive: $isLiveCameraViewActive
            ) {
                EmptyView()
            }
            Spacer()
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
