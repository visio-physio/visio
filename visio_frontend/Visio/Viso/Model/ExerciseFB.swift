//
//  ExerciseFB.swift
//  Viso
//
//  Created by person on 2023-02-02.
//

import Foundation
import SwiftUI

class ExerciseFB: ObservableObject, Identifiable {
    let id: Int
    let category: String
    let description: String
    let descriptionTitle: String
    let imageName: String
    let isFavorite: Bool
    let isFeatured: Bool
    let measurementField: String
    let measurementRange: String
    let test: String

    init(id: Int, category: String, description: String, descriptionTitle: String, imageName: String, isFavorite: Bool, isFeatured: Bool, measurementField: String, measurementRange: String, test: String) {
        self.id = id
        self.category = category
        self.description = description
        self.descriptionTitle = descriptionTitle
        self.imageName = imageName
        self.isFavorite = isFavorite
        self.isFeatured = isFeatured
        self.measurementField = measurementField
        self.measurementRange = measurementRange
        self.test = test
    }
    var image: Image {
        Image(imageName)
    }
}
