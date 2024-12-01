//
//  KUTeachApp.swift
//  KUTeach
//
//  Created by Sarp Vulaş on 10.01.2024.
//
import SwiftUI
@main
struct SeizureXpertApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var loginViewModel = LoginViewModel()

    var body: some Scene {
        WindowGroup {
            if loginViewModel.loginSuccessful {
                loginViewModel.destinationView
                    .environmentObject(loginViewModel)
                    .transition(.slide)
            } else {
                LoginView() // Start with LoginView instead of SignUpView
                    .environmentObject(loginViewModel)
                    .transition(.slide)
            }
        }
    }
}

