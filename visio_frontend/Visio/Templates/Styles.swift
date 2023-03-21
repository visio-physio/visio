//
//  Styles.swift
//  Viso
//
//  Created by person on 2023-03-20.
//

import Foundation
import UIKit
import SwiftUI

struct BackgroundStyle: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("BackgroundColor"), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .font(.custom("HKGrotesk-Regular", size: 12))
            content
        }
    }
}

struct SubtleBackgroundStyle: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [Color("BackgroundColor"), Color.white]), center: .center, startRadius: 5, endRadius: 500)
                .ignoresSafeArea()
                .font(.custom("HKGrotesk-Regular", size: 12))
            content
        }
    }
}

extension View {
    
    func backgroundStyle() -> some View {
        self.modifier(BackgroundStyle())
    }
    func subtleBackgroundStyle() -> some View {
        self.modifier(SubtleBackgroundStyle())
    }


}
