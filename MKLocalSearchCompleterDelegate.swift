//
//  MKLocalSearchCompleterDelegate.swift
//  UnityConnector
//
//  Created by TechnoLab on 11/2/24.
//

import SwiftUI
import MapKit

// Helper class to handle search completion
class SearchCompleterDelegate: NSObject, MKLocalSearchCompleterDelegate {
    var onUpdate: ([MKLocalSearchCompletion]) -> Void
    
    init(onUpdate: @escaping ([MKLocalSearchCompletion]) -> Void) {
        self.onUpdate = onUpdate
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        onUpdate(completer.results)
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error retrieving address suggestions: \(error.localizedDescription)")
    }
}
