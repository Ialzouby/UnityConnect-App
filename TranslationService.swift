//
//  TranslationService.swift
//  UnityConnector
//
//  Created by TechnoLab on 11/2/24.
//

import Foundation

class TranslationService {
    private let apiKey = "YOUR_OPENAI_API_KEY" // Replace with your actual OpenAI API key

    func translate(text: String, to targetLanguage: String, completion: @escaping (String?) -> Void) {
        let endpoint = "https://api.openai.com/v1/completions"
        
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let prompt = "Translate the following text to \(targetLanguage): \(text)"
        
        let json: [String: Any] = [
            "model": "text-davinci-003",
            "prompt": prompt,
            "max_tokens": 100
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: json)
        } catch {
            print("Error serializing JSON:", error)
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error making API call:", error?.localizedDescription ?? "Unknown error")
                completion(nil)
                return
            }

            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let choices = jsonResponse["choices"] as? [[String: Any]],
                   let translatedText = choices.first?["text"] as? String {
                    completion(translatedText.trimmingCharacters(in: .whitespacesAndNewlines))
                } else {
                    print("Unexpected response format.")
                    completion(nil)
                }
            } catch {
                print("Error parsing response:", error)
                completion(nil)
            }
        }
        task.resume()
    }
}
