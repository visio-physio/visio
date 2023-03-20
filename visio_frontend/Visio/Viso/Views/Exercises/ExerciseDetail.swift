import SwiftUI
import Firebase

struct ExerciseDetail: View {
    @EnvironmentObject var cam: CameraWebsocket
    @EnvironmentObject var load_exercises: LoadExercises
    @Environment(\.presentationMode) var presentationMode

    @State private var isLiveCameraViewActive = false
    @State  var selectedExercises: [Exercise]
    @State  var currentIndex: Int = 0

    let userID = Auth.auth().currentUser?.uid ?? "none"

    var body: some View {
        TabView {
            VStack {
                ScrollView {
                    VStack {
                        HStack {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Label("End Exam", systemImage: "xmark.circle")
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                if currentIndex > 0 {
                                    currentIndex -= 1
                                }
                            }) {
                                Label("Previous", systemImage: "arrow.left")
                            }
                            
                            Spacer()

                            Button(action: {
                                if currentIndex < selectedExercises.count - 1 {
                                    currentIndex += 1
                                }
                            }) {
                                Label("Next", systemImage: "arrow.right")
                            }
                        }
                        .padding(.top)
                        
                        Text("Results")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top)

                        ExerciseRangeOfMotionPlotView()
                            .environmentObject(Results(collection: "results", document: userID, exerciseType: selectedExercises[currentIndex].exercise + "-" + selectedExercises[currentIndex].bodyPart))

                        HStack {
                            CircleImage(image: selectedExercises[currentIndex].image)
                                .padding(.top, 20)

                            VStack(alignment: .leading) {
                                Text(selectedExercises[currentIndex].bodyPart + " " + selectedExercises[currentIndex].exercise)
                                    .font(.title)
                                    .fontWeight(.bold)
                                Text(selectedExercises[currentIndex].measurementField)
                                    .font(.headline)
                                    .padding(.top, 8)
                                Text(selectedExercises[currentIndex].measurementRange)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.leading)

                            Spacer()

                            FavoriteButton(isSet: $selectedExercises[currentIndex].isFavorite, exercise_id: selectedExercises[currentIndex].id)
                                .padding(.trailing)
                        }

                        Divider()
                            .padding(.vertical)

                        VStack(alignment: .leading, spacing: 16) {
                            Text(selectedExercises[currentIndex].descriptionTitle)
                                .font(.title2)
                                .fontWeight(.bold)

                            HStack(alignment: .top) {
                                Image(selectedExercises[currentIndex].imageExample)
                                    .resizable()
                                    .frame(width: 150, height: 150)

                                Text(selectedExercises[currentIndex].description)
                                    .padding(.leading)
                            }
                        }
                        .padding()

                        Spacer()
                        Button("Start Test") {
                            cam.send(userId: userID, bodyPart: selectedExercises[currentIndex].bodyPart, exercise: selectedExercises[currentIndex].exercise, state: "start")
                            isLiveCameraViewActive = true
                            print("sending to server: \(selectedExercises[currentIndex].exercise)")
                        }
                        .buttonStyle(LiveCameraButtonStyle())
                        .sheet(isPresented: $isLiveCameraViewActive) {
                            LiveCameraView()
                        }
                    }
                }
                .padding(.horizontal)
                .navigationBarTitle(Text(selectedExercises[currentIndex].bodyPart + " " + selectedExercises[currentIndex].exercise), displayMode: .inline)
            }
            .tabItem {
                Label("Exercise", systemImage: "person.circle")
            }

            ResultsView(exercise: selectedExercises[currentIndex].bodyPart + " " + selectedExercises[currentIndex].exercise)
                .environmentObject(Results(collection: "results", document: userID, exerciseType: selectedExercises[currentIndex].exercise + "-" + selectedExercises[currentIndex].bodyPart))
                .tabItem {
                    Label("Results", systemImage: "chart.line.uptrend.xyaxis")
                }
        }
        .navigationBarBackButtonHidden(true) // Add this line to hide the back button
    }
}

struct LiveCameraButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.green)
            .cornerRadius(10)
            .foregroundColor(.white)
    }
}

//struct ExerciseDetail_Previews: PreviewProvider {
//    static let load_data = LoadExercises()
//    static var exercise = load_data.exercises[0]
//    static var selectedExercises = [load_data.exercises[0], load_data.exercises[1], load_data.exercises[2]]
//
//    static var previews: some View {
//        ExerciseDetail(selectedExercises: selectedExercises)
//    }
//}
//
