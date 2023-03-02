//
//  ExerciseGraph.swift
//  Viso
//
//  Created by person on 2023-01-29.
//

import SwiftUI
import Charts

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        )
    }
}
struct ExerciseGraph: View {
    @EnvironmentObject var modelData: ExerciseResults
    var exerciseHist: ExerciseHist
    var path: KeyPath<ExerciseHist.Measurement, Int>

    var body: some View {
        let data = exerciseHist.measurements
        
        Chart{
            ForEach(Array(data.enumerated()), id: \.offset) { index, measurement in
                BarMark (
                    x: .value("Date", measurement.id),
                    y: .value("Range of Motion", measurement[keyPath: path])
                )
            }
        }
        .frame(height: 200)
    }
}

struct ExerciseGraph_Previews: PreviewProvider {
    static let exerciseHist = ExerciseResults().exerciseHists[0]

    static var previews: some View {
        ExerciseGraph(exerciseHist:exerciseHist, path: \.roi_right)
            .frame(height: 200)
    }
}
