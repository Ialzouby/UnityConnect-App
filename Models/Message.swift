//
//  Message.swift
//  UnityConnector
//
//  Created by TechnoLab on 11/2/24.
//

import Foundation
import FirebaseFirestore


struct Message: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var senderID: String
    var text: String
    var timestamp: Date? // Use Date here if converting from Timestamp
    var receiverID: String? // Make optional if not always provided
}
