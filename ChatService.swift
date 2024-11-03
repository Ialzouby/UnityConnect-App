import FirebaseFirestore
import FirebaseAuth

class ChatService {
    private let db = Firestore.firestore()
    private let translationService = TranslationService()

    // Fetches chats for the logged-in user
    func fetchChats(completion: @escaping ([Chat]) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }
        
        

        db.collection("chats")
            .whereField("participants", arrayContains: userID)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    print("Error fetching chats: \(error?.localizedDescription ?? "Unknown error")")
                    completion([])
                    return
                }
                
                let chats = documents.compactMap { document -> Chat? in
                    try? document.data(as: Chat.self)
                }
                
                completion(chats)
            }
    }
    
    func fetchMessages(for chatID: String, userPreferredLanguage: String, completion: @escaping ([Message]) -> Void) {
        db.collection("chats").document(chatID).collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching messages: \(error?.localizedDescription ?? "Unknown error")")
                    completion([])
                    return
                }
                
                var translatedMessages: [Message] = []
                
                // Translate each message to the preferred language
                let group = DispatchGroup()
                for document in documents {
                    if var message = try? document.data(as: Message.self) {
                        group.enter()
                        self.translationService.translate(text: message.text, to: userPreferredLanguage) { translatedText in
                            message.text = translatedText ?? message.text
                            translatedMessages.append(message)
                            group.leave()
                        }
                    }
                }
                
                group.notify(queue: .main) {
                    // Sort messages with nil timestamps at the beginning
                    completion(translatedMessages.sorted {
                        ($0.timestamp ?? Date.distantPast) < ($1.timestamp ?? Date.distantPast)
                    })
                }
            }
    }



    // Fetches the user ID by username
    func fetchUserIDByUsername(username: String, completion: @escaping (String?) -> Void) {
        db.collection("users").whereField("username", isEqualTo: username).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching user by username: \(error.localizedDescription)")
                completion(nil)
            } else if let document = snapshot?.documents.first {
                let userID = document.documentID
                completion(userID)
            } else {
                completion(nil)
            }
        }
    }

    // Creates a chat between the logged-in user and another user
    func createChat(with otherUserID: String, completion: @escaping (String) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let chatID = [userID, otherUserID].sorted().joined(separator: "_")
        let chatData: [String: Any] = [
            "participants": [userID, otherUserID],
            "timestamp": Timestamp(date: Date())
        ]
        
        db.collection("chats").document(chatID).setData(chatData) { error in
            if let error = error {
                print("Error creating chat: \(error.localizedDescription)")
            } else {
                completion(chatID)
            }
        }
    }

    func sendMessage(chatID: String, text: String, completion: @escaping (Error?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let messageData: [String: Any] = [
            "senderID": userID,
            "text": text,
            "timestamp": Timestamp(date: Date())
        ]
        
        db.collection("chats").document(chatID).collection("messages").addDocument(data: messageData) { error in
            completion(error)
        }
    }
    
    // Fetches a user's name by their ID
    func fetchUserName(for userID: String, completion: @escaping (String?) -> Void) {
        db.collection("users").document(userID).getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                print("Error fetching user name: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            let firstName = data["firstName"] as? String ?? ""
            let lastName = data["lastName"] as? String ?? ""
            completion("\(firstName) \(lastName)")
        }
    }
}
