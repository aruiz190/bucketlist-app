import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("Welcome to Bucket List")
                .font(.title)
                .bold()

            TextField("Email", text: $email)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Log In / Sign Up") {
                authVM.signIn(email: email, password: password) { _ in }
            }
            .buttonStyle(.borderedProminent)

            Button("Sign in with Google") {
                authVM.googleSignIn()
            }

            Button("Login with Facebook") {
                authVM.facebookLogin()
            }

            if let error = authVM.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding()
    }
}

