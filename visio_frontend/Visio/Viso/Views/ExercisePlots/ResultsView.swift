import SwiftUI
import Charts

struct ResultsView: View {
    var exercise: String
    @EnvironmentObject var results: Results
    
    @State private var selectedRange = "Left"

    var body: some View {
        VStack {
            Text("Results for \(exercise)")
                .font(.largeTitle)
                .padding()
            
            Divider()
            
            Picker("Range of Motion", selection: $selectedRange) {
                Text("Left").tag("Left")
                Text("Right").tag("Right")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            MotionGraph(dataPoints: results.datapoints, rangeType: selectedRange)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Latest Left Range of Motion: \(results.datapoints.last?.roi_left ?? 0, specifier: "%.2f")")
                    Text("Latest Right Range of Motion: \(results.datapoints.last?.roi_right ?? 0, specifier: "%.2f")")
                }
                Spacer()
            }
            .padding()
            
            // Add a summary section to show the overall improvement percentage
            // for both Left and Right Range of Motion

            Spacer()
        }
    }
}

struct MotionGraph: View {
    var dataPoints: [DataPoint]
    var rangeType: String

    @State private var lineWidth = 2.0
    @State private var chartColor: Color = .blue
    @State private var selectedElement: DataPoint? = nil
    @State private var showLollipop = true

    var body: some View {
        VStack {
            Chart(dataPoints, id: \.id) {
                LineMark(
                    x: .value("Date", $0.date().ISO8601Format()),
                    y: .value(rangeType, rangeType == "Left" ? $0.roi_left : $0.roi_right)
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


