//
//  Login.swift
//  Viso
//
//  Created by person on 2023-03-01.
//

import SwiftUI
import Firebase

struct Login: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""

    @State private var isRegistering: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.green, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack {
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)

                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.bottom, 20)

                    Button(action: {
                        Auth.auth().signIn(withEmail: self.email, password: self.password) { (result, error) in
                            if let error = error {
                                self.errorMessage = error.localizedDescription
                            } else {
                                // Handle successful login
                            }
                        }
                    }) {
                        Text("Log in")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(5.0)
                    }

                    Button(action: {
                        self.isRegistering = true
                    }) {
                        Text("Register")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(5.0)
                    }
                    .sheet(isPresented: $isRegistering) {
                        RegisterView()
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationBarTitle("Login")
        }
    }
}


struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
