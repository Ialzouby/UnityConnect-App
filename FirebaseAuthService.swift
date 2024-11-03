//
//  FirebaseAuthService.swift
//  UnityConnector
//
//  Created by TechnoLab on 11/2/24.
//

import Foundation
import FirebaseAuth

class FirebaseAuthService {
    
    func signUp(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let userID = authResult?.user.uid {
                completion(.success(userID))
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let userID = authResult?.user.uid {
                completion(.success(userID))
            }
        }
    }
}
