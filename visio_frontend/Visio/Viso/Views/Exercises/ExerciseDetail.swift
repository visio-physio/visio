import SwiftUI

struct ExerciseDetail: View {
    @EnvironmentObject var modelData: ModelData
    var exercise: ExerciseFB
    
    var exerciseIndex: Int {
        modelData.exercises.firstIndex(where: { $0.id == exercise.id })!
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
                        Text(exercise.test)
                            .font(.title2)
                        FavoriteButton(isSet: $modelData.exercises[exerciseIndex].isFavorite)

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
            
            NavigationLink("Start Test") {
                
                PoseVideoPlayer()
            }
            .foregroundColor(.green)
            Spacer()
            
//            NavigationLink("Connet to server Test") {
//                ServerConnectionTest()
//            }
//            .foregroundColor(.green)
            Spacer()
        }
        .padding()
    }
}


//struct ExerciseDetail_Previews: PreviewProvider {
//    static let modelData = ModelData()
//
//    static var previews: some View {
//        ExerciseDetail(exercise: modelData.exercises[0])
//            .environmentObject(modelData)
//    }
//}
