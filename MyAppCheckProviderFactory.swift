//
//  MyAppCheckProviderFactory.swift
//  UnityConnector
//
//  Created by TechnoLab on 11/2/24.
//

import FirebaseAppCheck
import Firebase

class MyAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
    func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
        if #available(iOS 14, *) {
            // Use App Attest for iOS 14+ devices
            return AppAttestProvider(app: app)
        } else {
            // Use Device Check for older devices
            return DeviceCheckProvider(app: app)
        }
    }
}
