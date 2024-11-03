import AVFoundation

class VoiceRecorder: NSObject {
    private let audioEngine = AVAudioEngine()
    private let audioSession = AVAudioSession.sharedInstance()

    func startRecording(audioChunkHandler: @escaping (Data) -> Void) {
        // Configure and activate the audio session
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
            return
        }

        // Get the hardware sample rate
        let hardwareSampleRate = audioSession.sampleRate
        print("Hardware sample rate: \(hardwareSampleRate)")

        // Set up audio format using the hardware sample rate to avoid conflicts
        guard let format = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: hardwareSampleRate, channels: 1, interleaved: true) else {
            print("Failed to create audio format")
            return
        }

        let inputNode = audioEngine.inputNode
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { (buffer, time) in
            let audioData = self.processAndResampleAudioBuffer(buffer: buffer, originalSampleRate: hardwareSampleRate, targetSampleRate: 16000)
            audioChunkHandler(audioData) // Send the resampled audio chunk to the handler
        }

        // Start the audio engine
        do {
            try audioEngine.start()
            print("Audio recording started")
        } catch {
            print("Failed to start audio engine: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        print("Audio recording stopped")
    }

    // Helper function to process and resample the audio buffer
    private func processAndResampleAudioBuffer(buffer: AVAudioPCMBuffer, originalSampleRate: Double, targetSampleRate: Double) -> Data {
        guard let channelData = buffer.int16ChannelData else {
            print("Failed to get channel data")
            return Data()
        }

        // Convert buffer data to array for resampling
        let originalData = Array(UnsafeBufferPointer(start: channelData[0], count: Int(buffer.frameLength)))
        let resampledData = resampleAudio(data: originalData, from: originalSampleRate, to: targetSampleRate)
        
        return Data(bytes: resampledData, count: resampledData.count * MemoryLayout<Int16>.size)
    }

    // Resample audio data to the target sample rate
    private func resampleAudio(data: [Int16], from originalSampleRate: Double, to targetSampleRate: Double) -> [Int16] {
        let resamplingFactor = targetSampleRate / originalSampleRate
        let resampledLength = Int(Double(data.count) * resamplingFactor)
        var resampledData = [Int16](repeating: 0, count: resampledLength)

        for i in 0..<resampledLength {
            let originalIndex = Int(Double(i) / resamplingFactor)
            resampledData[i] = data[originalIndex]
        }

        return resampledData
    }
}

