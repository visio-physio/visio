//
//  ExercisePlotDetails.swift
//  Viso
//
//  Created by person on 2023-01-29.
//

import SwiftUI
import Charts


struct ExercisePlotView: View {
    let exerciseHist: ExerciseResult
    @State var dataToShow = \ExerciseResult.Measurement.roi_left

    var buttons = [
        ("ROI Left", \ExerciseResult.Measurement.roi_left),
        ("ROI Right", \ExerciseResult.Measurement.roi_right)
    ]
    
    var body: some View {
        ExerciseGraph(exerciseHist: exerciseHist, path: dataToShow)
        HStack(spacing: 25) {
            ForEach(buttons, id: \.0) { value in
                Button {
                    dataToShow = value.1
                } label: {
                    Text(value.0)
                        .font(.system(size: 15))
                        .foregroundColor(value.1 == dataToShow
                            ? .gray
                            : .accentColor)
                        .animation(nil)
                }
            }
        }
        
    }
}

struct ExercisePlotDetails_Previews: PreviewProvider {
    static let modelData = ExerciseResults()

    static var previews: some View {
        ExercisePlotView(exerciseHist: modelData.exerciseHists[0])
            .environmentObject(modelData)
    }
}
