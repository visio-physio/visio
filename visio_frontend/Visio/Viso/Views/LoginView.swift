import SwiftUI
import Firebase
import UIKit

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var isRegistering: Bool = false
    @State private var isActive: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
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
                                print(self.errorMessage)
                            } else {
                                self.presentationMode.wrappedValue.dismiss() // dismiss LoginView
                                self.isActive = true
                                print("issss")
                            }
                        }
                    }) {
                        Text("Log in")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(5.0)
                    }
                    .navigationDestination(
                        isPresented: $isActive) {
                            ExerciseList()
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
                    .navigationDestination(
                        isPresented: $isRegistering) {
                            RegisterView()
                        }
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
