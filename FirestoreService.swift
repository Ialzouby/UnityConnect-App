//
//  FirestoreService.swift
//  UnityConnector
//
//  Created by TechnoLab on 11/2/24.
//

import Foundation
import FirebaseFirestore

class FirestoreService {
    private let db = Firestore.firestore()
    
    func addUserData(userID: String, name: String, email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("users").document(userID).setData([
            "name": name,
            "email": email
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func fetchUserData(userID: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        db.collection("users").document(userID).getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = document?.data() {
                completion(.success(data))
            }
        }
    }
}
