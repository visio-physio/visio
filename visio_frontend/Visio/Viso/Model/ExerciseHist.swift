/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Exercise Historical Results, used to show user progression over time.
*/

import Foundation

struct ExerciseHist: Codable, Hashable, Identifiable {
    var id: Int
    var name: String
    var measurements: [Measurement]

    struct Measurement: Codable, Hashable, Identifiable{
        var roi_left: Int
        var roi_right: Int
        var id: String
    }
}

struct ExerciseHist2: Codable, Hashable, Identifiable {
    var id: Int
    var name: String
    var measurements: [Measurement]

    struct Measurement: Codable, Hashable, Identifiable{
        var id: Double
        var roi_left: Int
        var roi_right: Int
    }
}
