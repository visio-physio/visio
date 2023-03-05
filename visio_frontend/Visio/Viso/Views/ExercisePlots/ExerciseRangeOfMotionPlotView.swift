////
////  ExerciseRangeOfMotionPlotView.swift
////  Viso
////
////  Created by person on 2023-03-04.
////
//
//import SwiftUI
//import Charts
//
//struct ExerciseRangeOfMotionPlotView: View {
//    @EnvironmentObject var results: Results
//
//    var body: some View {
//
//
//        Chart(results.datapoints) {
//            LineMark(
//                x: .value("Range of Motion Left", $0.id),
//                y: .value("Date", $0.roi_right)
//            )
//        }
//
//   }
//}
//
//struct ExerciseRangeOfMotionPlotView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExerciseRangeOfMotionPlotView()
//    }
//}

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
    @State private var plotType: String = "roi_left"

    var body: some View {
        VStack {
            if plotType == "roi_left" {
                Chart(results.datapoints) {
                    LineMark(
                        x: .value("Range of Motion Left", $0.id),
                        y: .value("Date", $0.roi_left)
                    )
                }
            } else if plotType == "roi_right" {
                Chart(results.datapoints) {
                    LineMark(
                        x: .value("Range of Motion Right", $0.id),
                        y: .value("Date", $0.roi_right)
                    )
                }
            } else if plotType == "combine" {
                Chart(results.datapoints) {
                    LineMark(
                        x: .value("Range of Motion Left", $0.id),
                        y: .value("Left", $0.roi_left)
                    )
                    LineMark(
                        x: .value("Range of Motion Right", $0.id),
                        y: .value("Right", $0.roi_right)
                    )
                }
            }

            Picker(selection: $plotType, label: Text("Select plot type")) {
                Text("Left").tag("roi_left")
                Text("Right").tag("roi_right")
//                Text("Combine").tag("combine")
            }.pickerStyle(SegmentedPickerStyle())
        }
   }
}

struct ExerciseRangeOfMotionPlotView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseRangeOfMotionPlotView()
    }
}

