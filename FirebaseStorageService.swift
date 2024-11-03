//
//  FirebaseStorageService.swift
//  UnityConnector
//
//  Created by TechnoLab on 11/2/24.
//

import Foundation
import FirebaseStorage

class FirebaseStorageService {
    private let storageRef = Storage.storage().reference()
    
    func uploadProfilePicture(imageData: Data, userID: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let profilePicRef = storageRef.child("profile_pictures/\(userID).jpg")
        profilePicRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            profilePicRef.downloadURL { (url, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url))
                }
            }
        }
    }
}
