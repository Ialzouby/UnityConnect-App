import SwiftUI

struct NewChatView: View {
    @State private var username = ""
    private let chatService = ChatService()
    var onCreateChat: (String) -> Void

    var body: some View {
        VStack {
            TextField("Enter username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Create Chat") {
                chatService.fetchUserIDByUsername(username: username) { userID in
                    guard let otherUserID = userID else {
                        print("User not found")
                        return
                    }
                    chatService.createChat(with: otherUserID) { chatID in
                        onCreateChat(chatID)
                    }
                }
            }
            .padding()
        }
    }
}
