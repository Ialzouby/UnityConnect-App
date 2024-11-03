//
//  UnityConnectorApp.swift
//  UnityConnector
//
//  Created by TechnoLab on 11/2/24.
//

import SwiftUI
import SwiftData
import Firebase
import FirebaseAuth
import FirebaseFirestore


@main
struct UnityConnectorApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    
    init() {
        let webSocketManager = WebSocketManager()
        webSocketManager.connect()
        
        FirebaseApp.configure()
        
        let providerFactory = MyAppCheckProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        
        Environment.shared.loadAPIKey { apiKey in
            if let apiKey = apiKey {
                print("Fetched OpenAI API Key: \(apiKey)")
            } else {
                print("Failed to retrieve OpenAI API Key from Remote Config")
            }
        }
    
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
