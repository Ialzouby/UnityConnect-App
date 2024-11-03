//
//  AuthViewModel.swift
//  UnityConnector
//
//  Created by TechnoLab on 11/2/24.
//

import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var userProfile: UserProfile?
    
    private let db = Firestore.firestore()
    
    init() {
        self.isLoggedIn = Auth.auth().currentUser != nil
        _ = Auth.auth().addStateDidChangeListener { _, user in
            self.isLoggedIn = user != nil
            if let userID = user?.uid {
                self.fetchUserProfile(userID: userID)
            }
        }
    }
    
    func signUp(email: String, password: String, username: String, firstName: String, lastName: String, preferredLanguage: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let userID = result?.user.uid else { return }
            
            let userData: [String: Any] = [
                "username": username,
                "firstName": firstName,
                "lastName": lastName,
                "preferredLanguage": preferredLanguage,
                "email": email,
                "userID": userID
            ]
            
            self.db.collection("users").document(userID).setData(userData) { error in
                completion(error)
            }
        }
    }
    

    
    func signOut() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
            userProfile = nil
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    private func fetchUserProfile(userID: String) {
        db.collection("users").document(userID).getDocument { document, error in
            if let document = document, document.exists, let data = document.data() {
                self.userProfile = UserProfile(
                    username: data["username"] as? String ?? "",
                    firstName: data["firstName"] as? String ?? "",
                    lastName: data["lastName"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    preferredLanguage: data["preferredLanguage"] as? String ?? ""
                )
            } else if let error = error {
                print("Error fetching user profile: \(error.localizedDescription)")
            }
        }
    }
}

struct UserProfile {
    let username: String
    let firstName: String
    let lastName: String
    let email: String
    let preferredLanguage: String
}
