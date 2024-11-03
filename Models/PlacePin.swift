//
//  PlacePin.swift
//  UnityConnector
//
//  Created by TechnoLab on 11/2/24.
//

import Foundation
import CoreLocation

struct PlacePin: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let description: String
}
