//
//  Exercise.swift
//  Viso
//
//  Created by person on 2023-01-28.
//

import Foundation
import SwiftUI
import CoreLocation

struct Exercise: Hashable, Codable, Identifiable {
    var id: Int
    var test: String
    var isFavorite: Bool
    var category: String
    var measurementFiled: String
    var measurementRange: String
    var descriptionTitle: String
    var description: String
    
    private var imageName: String
    var image: Image {
        Image(imageName)
    }
}
