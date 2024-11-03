import Foundation

class WebSocketManager: NSObject, URLSessionDelegate {
    private var webSocket: URLSessionWebSocketTask?
    private let urlString = "ws://192.168.86.55:8080"
    private var isReconnecting = false
    private var reconnectDelay = 1.0  // Start with 1-second delay
    
    private var audioBuffer = Data() // Buffer to hold accumulated audio data
    private let minBufferSize = 100000 // Increased buffer size for 150ms of audio at 16kHz

    func connect() {
        guard let url = URL(string: urlString) else { return }
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        webSocket = urlSession.webSocketTask(with: url)
        webSocket?.resume()
        
        // Reset reconnection variables
        isReconnecting = false
        reconnectDelay = 1.0

        receiveMessages()  // Start listening for messages
    }

    private func reconnect() {
        guard !isReconnecting else { return }
        isReconnecting = true
        
        print("Attempting to reconnect in \(reconnectDelay) seconds...")

        // Schedule reconnection with exponential backoff
        DispatchQueue.global().asyncAfter(deadline: .now() + reconnectDelay) { [weak self] in
            self?.connect()
            self?.reconnectDelay = min(self!.reconnectDelay * 2, 30.0)  // Cap at 30 seconds
        }
    }

    private func receiveMessages() {
        webSocket?.receive { [weak self] result in
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
                
                // Reset reconnection delay after successful communication
                self?.reconnectDelay = 1.0
                self?.receiveMessages() // Keep listening for messages
                
            case .failure(let error):
                print("Failed to receive message: \(error)")
                self?.reconnect()
            }
        }
    }

    func sendAudioChunk(_ audioChunk: Data) {
        // Append incoming audio data to the buffer
        audioBuffer.append(audioChunk)
        
        // Check if the buffer has accumulated at least 150ms of audio
        if audioBuffer.count >= minBufferSize {
            // Convert audio buffer to base64 and prepare the message
            let base64Audio = audioBuffer.base64EncodedString()
            let message = [
                "type": "audio_chunk",
                "audio": base64Audio
            ]
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: message) else { return }
            let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
            
            webSocket?.send(.string(jsonString)) { error in
                if let error = error {
                    print("Failed to send audio chunk: \(error)")
                } else {
                    print("Audio chunk sent successfully")
                }
            }
            
            // Clear the buffer after sending
            audioBuffer = Data()
        }
    }

    func stopSendingAudio() {
        webSocket?.cancel(with: .goingAway, reason: nil)
        print("WebSocket connection closed")
    }
}
