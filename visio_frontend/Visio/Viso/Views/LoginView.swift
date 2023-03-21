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
                VStack {
                    Text("Welcome Back!")
                        .foregroundColor(Color("HeadingColor"))
                        .padding(.bottom, 40)

                    TextField("Email", text: $email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
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
                    }
                    .buttonStyle(BlueButton())
                    .navigationDestination(
                        isPresented: $isActive) {
                            ExerciseList()
                        }

                    Button(action: {
                        self.isRegistering = true
                    }) {
                        Text("Register")
                    }
                    .buttonStyle(BlueButton())
                    .navigationDestination(
                        isPresented: $isRegistering) {
                            RegisterView()
                        }

                    Spacer()
                }
                .padding()
            }
            .backgroundStyle()
        }
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
