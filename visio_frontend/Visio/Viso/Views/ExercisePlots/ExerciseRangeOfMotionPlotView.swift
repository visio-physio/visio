import SwiftUI
import Charts

struct ExerciseRangeOfMotionPlotView: View {
    @EnvironmentObject var results: Results
    @State private var plotType: String = "roi_left"
    
    var body: some View {
        VStack {
            SinceGraph(dataPoints: results.currentData, rangeType: plotType)
        }

            Picker(selection: $plotType, label: Text("Select plot type")) {
                Text("Left").tag("roi_left")
                Text("Right").tag("roi_right")
//                Text("Combine").tag("combine")
            }.pickerStyle(SegmentedPickerStyle())
        }
        
            
}

struct SinceGraph: View {
    var dataPoints: [SinePoint]
    var rangeType: String

    @State private var lineWidth = 2.0
    @State private var chartColor: Color = .blue
    @State private var selectedElement: DataPoint? = nil
    @State private var showLollipop = true

    var body: some View {
        VStack {
            Chart(dataPoints, id: \.id) {
                LineMark(
                    x: .value("Date", $0.id),
                    y: .value(rangeType, rangeType == "roi_left" ? $0.left : $0.right)
                )
                .lineStyle(StrokeStyle(lineWidth: lineWidth))
                .foregroundStyle(chartColor.gradient)
                .symbol(Circle().strokeBorder(lineWidth: lineWidth))
                .symbolSize(60)

            }
            .chartXAxis(.automatic)
            .chartYAxis(.automatic)
            .frame(height: 300)
        }
    }
}
