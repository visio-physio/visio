import SwiftUI

struct ExerciseList: View {
    @EnvironmentObject var load_exercises: LoadExercises
    @EnvironmentObject var camera_socket: CameraWebsocket

    @State private var showFavoritesOnly = false
    @State private var url = UserDefaults.standard.string(forKey: "url") ?? "https://b898-2607-9880-1aa0-cd-1374-87be-b01b-c4c2.ngrok.io/"

    var filteredExercises: [Exercise] {
        load_exercises.exercises.filter { exercise in
            (!showFavoritesOnly || exercise.isFavorite)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Text("Viso")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Pose Estimation for Physiotherapists")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)

                Toggle(isOn: $showFavoritesOnly) {
                    Text("Favorites only")
                }
                .toggleStyle(SwitchToggleStyle(tint: .blue))
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
                            .fontWeight(.bold)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 20)

                let columns = [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ]

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(filteredExercises) { exercise in
                            NavigationLink(destination: ExerciseDetail(exercise: exercise)) {
                                ExerciseRow(exercise: exercise)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ExerciseList_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseList()
            .environmentObject(LoadExercises())
    }
}
