//
//  Styles.swift
//  Viso
//
//  Created by person on 2023-03-20.
//

import Foundation
import UIKit
import SwiftUI

struct BlueButton: ButtonStyle {
    @State private var isPressed = false
    @State private var feedbackGenerator = UINotificationFeedbackGenerator()

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color("ButtonColor"))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
            .onChange(of: configuration.isPressed) { newValue in
                if newValue {
                    feedbackGenerator.prepare()
                    feedbackGenerator.notificationOccurred(.success)
                }
                withAnimation {
                    isPressed = newValue
                }
            }
    }
}

struct BackgroundStyle: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("BackgroundColor"), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            content
        }
    }
}

struct SubtleBackgroundStyle: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [Color("BackgroundColor"), Color.white]), center: .center, startRadius: 5, endRadius: 500)
                .ignoresSafeArea()
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
