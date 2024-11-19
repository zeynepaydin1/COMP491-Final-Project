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
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("Firebase configured successfully")
        return true
    }
}
