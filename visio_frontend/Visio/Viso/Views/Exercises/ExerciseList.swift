import SwiftUI

struct ExerciseList: View {
    @EnvironmentObject var load_exercises: LoadExercises
    @EnvironmentObject var camera_socket: CameraWebsocket

    @State private var showFavoritesOnly = false
    @State private var url = UserDefaults.standard.string(forKey: "url") ?? "https://b898-2607-9880-1aa0-cd-1374-87be-b01b-c4c2.ngrok.io/"
    @State private var selectedExercises: Set<Int> = []
    
    var filteredExercises: [Exercise] {
        load_exercises.exercises.filter { exercise in
            (!showFavoritesOnly || exercise.isFavorite)
        }
    }
    
    var selectedExercisesArray: [Exercise] {
        filteredExercises.filter { exercise in
            selectedExercises.contains(exercise.id)
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                
                    HStack {
                        Text("Viso")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        .foregroundColor(Color("HeadingColor"))
                        
                        Image("AppIcon")
                    }
                    Text("Pose Estimation for Physiotherapists")
                        .font(.headline)
                        .foregroundColor(Color("SubHeadingColor"))
                }
                .padding(.top, 20)

                Toggle(isOn: $showFavoritesOnly) {
                    Text("Favorites only")
                        .foregroundColor(Color("HeadingColor"))
                }
                .toggleStyle(SwitchToggleStyle(tint: Color("SubHeadingColor")))
                .padding(.bottom, 10)

                HStack {
                    TextField("Enter URL", text: $url)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)

                    Button(action: {
                        print("URL: \(url)")
                        camera_socket.url = url
                        camera_socket.makeConnection()
                        UserDefaults.standard.set(url, forKey: "url")
                    }) {
                        Text("Connect")
                    }
                    .buttonStyle(BlueButton())
                }
                .padding(.bottom, 20)

                let columns = [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ]

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(filteredExercises) { exercise in
                            Button(action: {
                                if selectedExercises.contains(exercise.id) {
                                    selectedExercises.remove(exercise.id)
                                } else {
                                    selectedExercises.insert(exercise.id)
                                }
                            }) {
                                ExerciseRow(exercise: exercise)
                                    .background(selectedExercises.contains(exercise.id) ? Color.blue.opacity(0.3) : Color.clear)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    
                    NavigationLink(destination: ExerciseDetail(selectedExercises: selectedExercisesArray)) {
                        Text("Perform Measurements")
                    }
                    .buttonStyle(BlueButton())
                    .disabled(selectedExercisesArray.isEmpty)
                }
                .padding(.bottom, 20)
            }
            .padding()
            .onAppear {
                  selectedExercises.removeAll()
              }
        }
        .subtleBackgroundStyle()
        .navigationBarBackButtonHidden(true)
    }
}

//struct ExerciseList_Previews: PreviewProvider {
//    static var previews: some View {
//        ExerciseList()
//            .environmentObject(LoadExercises())
//
//    }
//}
