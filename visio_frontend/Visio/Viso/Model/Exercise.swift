import Foundation
import SwiftUI

struct Exercise: Hashable, Codable, Identifiable {
    var id: Int
    let exercise: String
    let bodyPart: String
    var isFavorite: Bool
    let measurementField: String
    let measurementRange: String
    let descriptionTitle: String
    let description: String
    let imageName: String
    
    var image: Image {
        Image(imageName)
    }
}


