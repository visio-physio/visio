//
//  ResultsView.swift
//  Viso
//
//  Created by person on 2023-03-02.
//

import SwiftUI

struct ResultsView: View {
    let get_data = Results()
    var body: some View {
        VStack{
            Text("Hello, World!")
            
            Button(action:{
                get_data.loadResults()
//                get_data.read()
            }){
                Text("button")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(5.0)
            }
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView()
    }
}
