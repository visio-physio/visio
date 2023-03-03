//
//  ContentView.swift
//  Viso
//
//  Created by person on 2023-01-28.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LoginView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(LoadExercises())
    }
}
