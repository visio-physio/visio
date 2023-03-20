import SwiftUI
import Firebase

struct ExerciseDetail: View {
    @EnvironmentObject var cam: CameraWebsocket
    @State private var isLiveCameraViewActive = false

    @State var exercise: Exercise
    let userID = Auth.auth().currentUser?.uid ?? "none"

    
    @State private var isShowVideo = false
    var body: some View {
        TabView {
            NavigationStack {
                VStack {
                    Text("Results")
                    ExerciseRangeOfMotionPlotView()
                        .environmentObject(Results(collection: "results", document: userID, exerciseType: exercise.exercise + "-" + exercise.bodyPart))
                    HStack {
                        CircleImage(image: exercise.image)
                        VStack(alignment: .leading) {
                            HStack {
                                Text(exercise.bodyPart + " " + exercise.exercise)
                                    .font(.title2)
                                FavoriteButton(isSet: $exercise.isFavorite, exercise_id: exercise.id)
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
                    
                    HStack{
                        Image(exercise.imageExample)
                            .resizable()
                            .frame(width: 200, height: 200)
                        Text(exercise.description)
                            .padding()
                    }

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
                .padding()
                .navigationBarTitle(Text(exercise.bodyPart + " " + exercise.exercise))
            }
            .tabItem {
                Label("Exercise", systemImage: "person.circle")
            }

            ResultsView(exercise: exercise.bodyPart + " " + exercise.exercise)
                .environmentObject(Results(collection: "results", document: userID, exerciseType: exercise.exercise + "-" + exercise.bodyPart))
                .tabItem {
                    Label("Results", systemImage: "chart.line.uptrend.xyaxis")
                }
        }
    }
}

struct ExerciseDetail_Previews: PreviewProvider {
    static let load_data = LoadExercises()
    static var exercise = load_data.exercises[0]

    static var previews: some View {
        ExerciseDetail(exercise: exercise)
            .environmentObject(load_data)
    }
}

