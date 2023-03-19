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
                ScrollView {
                    VStack {
                        Text("Results")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top)
                        
                        ExerciseRangeOfMotionPlotView()
                            .environmentObject(Results(collection: "results", document: userID, exerciseType: exercise.exercise + "-" + exercise.bodyPart))
                        
                        HStack {
                            CircleImage(image: exercise.image)
                                .padding(.top, 20)
                            
                            VStack(alignment: .leading) {
                                Text(exercise.bodyPart + " " + exercise.exercise)
                                    .font(.title)
                                    .fontWeight(.bold)
                                Text(exercise.measurementField)
                                    .font(.headline)
                                    .padding(.top, 8)
                                Text(exercise.measurementRange)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.leading)
                            
                            Spacer()
                            
                            FavoriteButton(isSet: $exercise.isFavorite, exercise_id: exercise.id)
                                .padding(.trailing)
                        }
                        
                        Divider()
                            .padding(.vertical)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text(exercise.descriptionTitle)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            HStack(alignment: .top) {
                                Image(exercise.imageExample)
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                
                                Text(exercise.description)
                                    .padding(.leading)
                            }
                            
          
                        }
                        .padding()
                        
                        Spacer()
                        Button("Start Test") {
                            cam.send(userId: userID, bodyPart: self.exercise.bodyPart, exercise: self.exercise.exercise, state: "start")
                            isLiveCameraViewActive = true
                            print("sending to server: \(self.exercise.exercise)")
                        }
                        .buttonStyle(LiveCameraButtonStyle())
                        .sheet(isPresented: $isLiveCameraViewActive) {
                            LiveCameraView()
                        }
                        
                    }
                }
                .padding(.horizontal)
                .navigationBarTitle(Text(exercise.bodyPart + " " + exercise.exercise), displayMode: .inline)
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

struct ExerciseDetail_Previews: PreviewProvider {
    static let load_data = LoadExercises()
    static var exercise = load_data.exercises[0]
    
    static var previews: some View {
        ExerciseDetail(exercise: exercise)
        
    }
    
}
