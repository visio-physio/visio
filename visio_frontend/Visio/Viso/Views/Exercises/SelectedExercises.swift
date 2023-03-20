//import SwiftUI
//import Firebase
//
//struct TestView: View {
//    @EnvironmentObject var load_exercises: LoadExercises
//    @EnvironmentObject var cam: CameraWebsocket
//    @State private var isLiveCameraViewActive = false
//    @State private var selectedExerciseDetail: Exercise?
//
//    let userID = Auth.auth().currentUser?.uid ?? "none"
//    var selectedExercises: Set<Int>
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                Text("Selected Exercises")
//                    .font(.title2)
//                    .padding(.bottom)
//
//                let columns = [
//                    GridItem(.flexible()),
//                    GridItem(.flexible())
//                ]
//
//                ScrollView {
//                    LazyVGrid(columns: columns, spacing: 20) {
//                        ForEach(Array(selectedExercises), id: \.self) { exerciseID in
//                            if let exercise = load_exercises.exercises.first(where: { $0.id == exerciseID }) {
//                                Button(action: {
//                                    selectedExerciseDetail = exercise
//                                }) {
//                                    VStack(alignment: .leading) {
//                                        Text(exercise.bodyPart + " " + exercise.exercise)
//                                            .font(.title3)
//                                            .padding(.bottom)
//                                    }
//                                    .frame(maxWidth: .infinity)
//                                    .padding()
//                                    .background(Color(.systemGray6))
//                                    .cornerRadius(10)
//                                }
//                                .sheet(item: $selectedExerciseDetail) { exercise in
//                                    ExerciseDetail(exercise: exercise)
//                                        .environmentObject(cam)
//                                        .environmentObject(load_exercises)
//                                }
//                            }
//                        }
//                    }
//                }
//                .padding(.bottom, 20)
//            }
//            .padding()
//            .navigationBarTitle(Text("Perform Measurements"))
//        }
//    }
//}
//
//struct TestView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestView(selectedExercises: Set([1, 2]))
//            .environmentObject(LoadExercises())
//    }
//}
