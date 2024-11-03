//
//  chat.swift
//  UnityConnector
//
//  Created by TechnoLab on 11/2/24.
//

import FirebaseFirestore
import Foundation

struct Chat: Identifiable, Codable {
    @DocumentID var id: String?
    var participants: [String]
    var lastMessage: String?
    var timestamp: Timestamp?
    
    // Array to hold the names of participants
}
