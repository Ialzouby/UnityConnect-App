//
//  Event.swift
//  UnityConnector
//
//  Created by TechnoLab on 11/2/24.
//

import Foundation

struct Event: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let date: Date
}
