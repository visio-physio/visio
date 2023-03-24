import SwiftUI
import Charts
import PencilKit

struct ResultsView: View {
    var exercise: String
    @EnvironmentObject var results: Results
    @State private var tool: PKTool = PKInkingTool(.pen, color: .black, width: 10)
    @State private var selectedRange = "Left"
    @State private var canvas = PKCanvasView()
    
    private var initialLeftRange: Double {
        results.datapoints.first?.roi_left ?? 0
    }
    
    private var initialRightRange: Double {
        results.datapoints.first?.roi_right ?? 0
    }
    
    private var latestLeftRange: Double {
        results.datapoints.last?.roi_left ?? 0
    }
    
    private var latestRightRange: Double {
        results.datapoints.last?.roi_right ?? 0
    }
    
    private var leftImprovementPercentage: Double {
        ((latestLeftRange - initialLeftRange) / initialLeftRange) * 100
    }
    
    private var rightImprovementPercentage: Double {
        ((latestRightRange - initialRightRange) / initialRightRange) * 100
    }

    var body: some View {
        
        ScrollView {
            VStack {
                Text("Results for \(exercise.capitalized)")
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
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Summary")
                        .font(.title2)
                        .bold()
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Latest Left Range of Motion:")
                            Text("Latest Right Range of Motion:")
                        }
                        VStack(alignment: .leading, spacing: 6) {
                            Text("\(latestLeftRange, specifier: "%.2f")")
                            Text("\(latestRightRange, specifier: "%.2f")")
                        }
                        Spacer()
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Left Improvement:")
                            Text("Right Improvement:")
                        }
                        VStack(alignment: .leading, spacing: 6) {
                            Text("\(leftImprovementPercentage, specifier: "%.2f")%")
                            Text("\(rightImprovementPercentage, specifier: "%.2f")%")
                        }
                        Spacer()
                    }
                }
                .padding()
                
                VStack(alignment: .leading) {
                    Text("Notes")
                        .font(.title2)
                        .bold()
                    
                    DrawingView(canvas: $canvas)
                        .frame(height: 300)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 4)
                    
                }
                .padding()

                Spacer()
            }
        }
    }
}

struct DrawingView: UIViewRepresentable {
    @Binding var canvas: PKCanvasView

    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        canvas.tool = PKInkingTool(.pen, color: .black, width: 10)
        return canvas
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
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


