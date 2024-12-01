//
//  AppDelegate.swift
//  KUTeach
//
//  Created by Zeynep Aydın on 1/10/24.
//
import Foundation
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseAppCheck

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("Firebase configured successfully")

        // Use Debug App Check Provider in debug builds
        #if DEBUG
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        print("Debug App Check Provider enabled")
        #endif

        return true
    }
}

