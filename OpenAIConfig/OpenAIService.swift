import Foundation

class OpenAIService {

    private var webSocket: URLSessionWebSocketTask?
    private var isConnected = false
    private let maxRetries = 3
    private var currentRetries = 0

    // Function to connect to the WebSocket server
    func connectToWebSocket() {
        guard let serverURL = URL(string: "ws://192.168.86.55:8080") else {
            print("Invalid server URL")
            return
        }

        let session = URLSession(configuration: .default)
        webSocket = session.webSocketTask(with: serverURL)
        webSocket?.resume()
        
        // Set the connection status
        isConnected = true

        // Start receiving messages
        receiveMessage()
    }

    // Function to send audio data to the WebSocket server
    func sendAudio(url: URL, completion: @escaping (String?) -> Void) {
        if !isConnected {
            connectToWebSocket()
        }

        guard let audioData = try? Data(contentsOf: url) else {
            print("Failed to read audio data")
            completion(nil)
            return
        }

        let base64Audio = audioData.base64EncodedString()
        let json: [String: Any] = [
            "type": "audio",
            "audio": base64Audio
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else {
            print("Failed to create JSON payload")
            completion(nil)
            return
        }

        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            print("Failed to convert JSON data to string")
            return
        }

        sendMessage(jsonString, retries: maxRetries, completion: completion)
    }

    private func sendMessage(_ message: String, retries: Int, completion: @escaping (String?) -> Void) {
        guard retries > 0 else {
            print("Max retries reached")
            completion(nil)
            return
        }

        webSocket?.send(.string(message)) { [weak self] error in
            if let error = error {
                print("Failed to send message: \(error.localizedDescription)")
                self?.sendMessage(message, retries: retries - 1, completion: completion) // Retry
            } else {
                print("Audio data sent successfully")
                completion("Success")
            }
        }
    }

    private func receiveMessage() {
        webSocket?.receive { [weak self] (result: Result<URLSessionWebSocketTask.Message, Error>) in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received text: \(text)")
                case .data(let data):
                    print("Received data: \(data)")
                @unknown default:
                    break
                }
            case .failure(let error):
                print("Failed to receive message: \(error.localizedDescription)")
            }

            // Keep listening for messages
            self?.receiveMessage()
        }
    }

    func disconnectWebSocket() {
        webSocket?.cancel(with: .goingAway, reason: nil) // Correct CloseCode enum usage
        isConnected = false
    }
}
