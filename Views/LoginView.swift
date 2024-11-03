//
//  LoginView.swift
//  UnityConnector
//
//  Created by TechnoLab on 11/2/24.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var showSignUp = false // Added @State for showing SignUpView
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
                .padding(.bottom, 20)
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button("Log In") {
                login()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.top)
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            // Button to show SignUpView
            Button("Don't have an account? Sign Up") {
                showSignUp.toggle() // Toggle showSignUp to show SignUpView
            }
            .foregroundColor(.blue)
            .padding(.top)
            .sheet(isPresented: $showSignUp) {
                SignUpView().environmentObject(authViewModel)
            }
        }
        .padding()
    }

    // Ensure the login function is within the LoginView struct
    private func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = "Error: \(error.localizedDescription)"
            } else {
                errorMessage = ""
                authViewModel.isLoggedIn = true
            }
        }
    }
}
