import SwiftUI
import Firebase

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String = ""
    @State private var isRegistered: Bool = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
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

                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)

                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.bottom, 20)

                Button(action: {
                    if password == confirmPassword {
                        Auth.auth().createUser(withEmail: self.email, password: self.password) { (result, error) in
                            if let error = error {
                                self.errorMessage = error.localizedDescription
                            } else {
                                // Handle successful registration
                                self.isRegistered = true
                            }
                        }
                    } else {
                        self.errorMessage = "Passwords do not match"
                    }
                }) {
                    Text("Register")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(5.0)
                }

                Spacer()
            }
            .padding()
        }
        .alert(isPresented: $isRegistered) {
            Alert(title: Text("Success"), message: Text("Registration successful"), dismissButton: .default(Text("OK"), action: {
                self.presentationMode.wrappedValue.dismiss() // dismiss RegisterView
            }))
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
