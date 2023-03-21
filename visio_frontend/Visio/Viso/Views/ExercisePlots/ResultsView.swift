//
//  ResultsView.swift
//  Viso
//
//  Created by person on 2023-03-05.
//

import SwiftUI
import Charts

struct ResultsView: View {
    var exercise: String
    @EnvironmentObject var results: Results
    
    @State private var plotType: String = "roi_left"
    
    var body: some View {
        VStack {
            Text("Results for \(exercise)")
            
            Divider()
            
            Text("Left Range of Motion")
            Chart(results.datapoints) {
                LineMark(
                    x: .value("Range of Motion Left", $0.id),
                    y: .value("Date", $0.roi_left)
                )
            }
            
            Text("Right Range of Motion")
            Chart(results.datapoints) {
                LineMark(
                    x: .value("Range of Motion Right", $0.id),
                    y: .value("Date", $0.roi_right)
                )
            }
            
        }
    }
    
}

//struct ResultsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultsView(exercise: "shoulder_abduction")
//    }
//}
//
//
