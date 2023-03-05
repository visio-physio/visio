//
//  SettingsView.swift
//  Viso
//
//  Created by person on 2023-02-22.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        List{
            Section(header: Text("Camera Settings")){
                VStack(){
                    HStack(){
                        Text("URL:")
                    }
                    HStack(){
                        Text("Port:")
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
