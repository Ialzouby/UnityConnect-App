import SwiftUI
import AVFoundation
import Speech

struct HomeView: View {
    @State private var chatResponse = ""
    @State private var isRecording = false
    private let speechSynthesizer = AVSpeechSynthesizer()
    private var openAIService = OpenAIService()
    private var voiceRecorder = VoiceRecorder()
    private var webSocketManager = WebSocketManager() // Add WebSocketManager instance

    var body: some View {
        VStack(spacing: 20) {
            Text("ChatGPT Voice Assistant")
                .font(.largeTitle)
                .padding()

            if !chatResponse.isEmpty {
                Text("ChatGPT: \(chatResponse)")
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }

            Button(action: toggleRecording) {
                Image(systemName: isRecording ? "mic.circle.fill" : "mic.circle")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(isRecording ? .red : .blue)
            }
            .padding()
        }
        .onAppear {
            requestSpeechAuthorization()
            webSocketManager.connect() // Connect to the WebSocket server when the view appears
        }
    }

    private func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }

    private func startRecording() {
        isRecording = true
        voiceRecorder.startRecording { audioChunk in
            // Send audio chunks in real time to the WebSocket without converting to base64
            webSocketManager.sendAudioChunk(audioChunk)
        }
    }

    private func stopRecording() {
        isRecording = false
        voiceRecorder.stopRecording()
        webSocketManager.stopSendingAudio() // Stop sending audio data
    }

    private func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(utterance)
    }

    private func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                print("Speech recognition authorized")
            default:
                print("Speech recognition authorization denied")
            }
        }
    }
}
