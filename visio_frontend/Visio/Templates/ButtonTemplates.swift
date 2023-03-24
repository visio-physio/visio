//
//  ButtonTemplates.swift
//  Viso
//
//  Created by person on 2023-03-21.
//

import Foundation
import SwiftUI

struct EndExamButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label("End Exam", systemImage: "xmark.circle")
        }
        .buttonStyle(NavButtons(isEnabled:true))
    }
}

struct PreviousButton: View {
    let action: () -> Void
    let isEnabled: Bool
    var body: some View {
        Button(action: action) {
            Label("Previous", systemImage: "arrow.left")
        }
        .buttonStyle(NavButtons(isEnabled: isEnabled))
    }
}

struct NextButton: View {
    let action: () -> Void
    let isEnabled: Bool

    var body: some View {
        Button(action: action) {
            Label("Next", systemImage: "arrow.right")
        }
        .buttonStyle(NavButtons(isEnabled: isEnabled))
        .disabled(!isEnabled)
    }
}

// Button Styles

struct BlueButton: ButtonStyle {
    @State private var isPressed = false
    @State private var feedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color("ButtonColor"))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(isPressed ? 0.85 : 1)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
            .onChange(of: configuration.isPressed) { newValue in
                if newValue {
                    feedbackGenerator.prepare()
                } else {
                    feedbackGenerator.impactOccurred()
                }
                withAnimation {
                    isPressed = newValue
                }
            }
    }
}


struct NavButtons: ButtonStyle {
    @State private var isPressed = false
    @State private var feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    let isEnabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        let color = isEnabled ? Color("ButtonColor") : Color(.systemGray)
        configuration.label
            .padding()
            .scaledToFit()
            .font(.custom("HKGrotestk-Medium", size: 14))
            .background(color)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.85 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { newValue in
                if newValue {
                    feedbackGenerator.prepare()
                } else {
                    feedbackGenerator.impactOccurred()
                }
                withAnimation {
                    self.isPressed = newValue
                }
            }
    }
}
