//
//  SettingView.swift
//  Viso
//
//  Created by person on 2023-03-02.
//

import SwiftUI

class WebSocketURL: ObservableObject {
    @Published var url = "https://1.com"
}

struct SettingsView: View {
    // Inject the shared WebSocketURL object into the view
    @EnvironmentObject var webSocketURL: WebSocketURL
    
    var body: some View {
        VStack {
            Text("WebSocket URL")
                .font(.headline)
                .padding()
            
            TextField("Enter URL", text: $webSocketURL.url)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
        .navigationBarTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let url = WebSocketURL()
        return SettingsView()
            .environmentObject(url)
    }
}

