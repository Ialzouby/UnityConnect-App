//
//  MessageService.swift
//  UnityConnector
//
//  Created by TechnoLab on 11/2/24.
//

import FirebaseFirestore
import FirebaseAuth

class MessageService {
    private let db = Firestore.firestore()
    
    func sendMessage(senderID: String, receiverID: String, text: String, completion: @escaping (Error?) -> Void) {
        let chatID = [senderID, receiverID].sorted().joined()
        let messageData: [String: Any] = [
            "senderID": senderID,
            "receiverID": receiverID,
            "text": text,
            "timestamp": Timestamp(date: Date())
        ]
        
        db.collection("chats").document(chatID).collection("messages").addDocument(data: messageData) { error in
            completion(error)
        }
    }
    
    func fetchMessages(chatID: String, completion: @escaping ([Message]) -> Void) {
        db.collection("chats").document(chatID).collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching messages: \(error?.localizedDescription ?? "Unknown error")")
                    completion([])
                    return
                }

                let messages = documents.compactMap { document -> Message? in
                    try? document.data(as: Message.self)
                }
                
                // Ensure completion is called on the main thread
                DispatchQueue.main.async {
                    completion(messages)
                }
            }
    }

    }

