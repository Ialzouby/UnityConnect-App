import SwiftUI
import FirebaseAuth


struct ChatListView: View {
    @State private var chats: [Chat] = []
    private let chatService = ChatService()
    @State private var showNewChatView = false
    
    // Dictionary to map chat IDs to participant names
    @State private var participantNames: [String: String] = [:]
    
    var body: some View {
        NavigationView {
            List(chats) { chat in
                NavigationLink(destination: ChatView(chatID: chat.id ?? "")) {
                    VStack(alignment: .leading) {
                        // Display participant names from the dictionary
                        Text(participantNames[chat.id ?? ""] ?? "Loading...")
                            .font(.headline)
                        
                        Text(chat.lastMessage ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Chats")
            .navigationBarItems(trailing: Button(action: {
                showNewChatView.toggle()
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showNewChatView) {
                NewChatView { newChatID in
                    self.showNewChatView = false
                }
            }
            .onAppear {
                loadChats()
            }
        }
    }
    
    private func loadChats() {
        chatService.fetchChats { fetchedChats in
            self.chats = fetchedChats
            
            let dispatchGroup = DispatchGroup()
            var namesDict: [String: String] = [:]
            
            guard let currentUserID = Auth.auth().currentUser?.uid else { return }
            
            // Fetch names for each chat's recipient (other than the logged-in user)
            for chat in fetchedChats {
                // Exclude the current user ID from participants to get the recipient's ID
                if let recipientID = chat.participants.first(where: { $0 != currentUserID }) {
                    dispatchGroup.enter()
                    
                    // Fetch the recipient's name
                    chatService.fetchUserName(for: recipientID) { name in
                        if let name = name {
                            namesDict[chat.id ?? ""] = name // Map chat ID to recipient's name
                        }
                        dispatchGroup.leave()
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self.participantNames = namesDict
            }
        }
    }

    
}
