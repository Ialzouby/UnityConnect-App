import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ChatView: View {
    @State private var messages: [Message] = []
    @State private var newMessageText = ""
    @State private var userPreferredLanguage: String? = nil
    private let chatService = ChatService()
    var chatID: String
    
    struct MessageRow: View {
        let message: Message
        
        var body: some View {
            HStack(alignment: .top) {
                if message.senderID == Auth.auth().currentUser?.uid {
                    Spacer() // Aligns sent messages to the right
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(message.text)
                        .padding(10)
                        .background(message.senderID == Auth.auth().currentUser?.uid ? Color.blue : Color.gray.opacity(0.2))
                        .foregroundColor(message.senderID == Auth.auth().currentUser?.uid ? .white : .black)
                        .cornerRadius(10)
                }
                
                if message.senderID != Auth.auth().currentUser?.uid {
                    Spacer() // Aligns received messages to the left
                }
                
                // Display timestamp
                if let timestamp = message.timestamp {
                    Text("\(timestamp, formatter: DateFormatter.shortTime)")
                        .font(.caption)
                        .foregroundColor(.gray)
                } else {
                    Text("N/A") // Fallback for missing timestamps
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            // Message List
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(messages) { message in
                            MessageRow(message: message)
                                .id(message.id) // Ensure each message has a unique ID for scrolling
                        }
                    }
                    .padding()
                    .onAppear {
                        if let lastMessage = messages.last {
                            scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                    .onChange(of: messages) {
                        if let lastMessage = messages.last {
                            scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }

            // Message Input Field
            HStack {
                TextField("Enter message", text: $newMessageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: 40)

                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                }
                .disabled(newMessageText.isEmpty)
            }
            .padding()
        }
        .navigationTitle("Chat")
        .onAppear {
            fetchUserPreferredLanguage { language in
                userPreferredLanguage = language
                loadMessages()
            }
        }
    }

    private func loadMessages() {
        guard let preferredLanguage = userPreferredLanguage else { return }
        chatService.fetchMessages(for: chatID, userPreferredLanguage: preferredLanguage) { fetchedMessages in
            if fetchedMessages.isEmpty {
                print("No messages found or failed to fetch messages.")
            }
            self.messages = fetchedMessages
        }
    }

    private func fetchUserPreferredLanguage(completion: @escaping (String?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { document, error in
            if let error = error {
                print("Error fetching user profile: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let document = document, let data = document.data(), let preferredLanguage = data["preferredLanguage"] as? String {
                completion(preferredLanguage)
            } else {
                completion(nil)
            }
        }
    }

    private func sendMessage() {
        let text = newMessageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        chatService.sendMessage(chatID: chatID, text: text) { error in
            if let error = error {
                print("Error sending message: \(error.localizedDescription)")
            } else {
                newMessageText = ""
            }
        }
    }
}

extension DateFormatter {
    static let shortTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a" // Display time in "Hour:Minute AM/PM" format
        return formatter
    }()
}
