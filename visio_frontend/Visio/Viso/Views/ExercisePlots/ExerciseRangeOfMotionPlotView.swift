//
//  ExerciseRangeOfMotionPlotView.swift
//  Viso
//
//  Created by person on 2023-03-04.
//

import SwiftUI
import Charts

struct ExerciseRangeOfMotionPlotView: View {
    @EnvironmentObject var results: Results

    var body: some View {
        
        
        Chart(results.datapoints) {
            LineMark(
                x: .value("Range of Motion Left", $0.id),
                y: .value("Date", $0.roi_right)
            )
        }
        
   }
}

struct ExerciseRangeOfMotionPlotView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseRangeOfMotionPlotView()
    }
}
