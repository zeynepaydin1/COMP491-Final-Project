import Foundation
import SwiftUI
import UIKit

struct UIKitStarterView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        // Create the Splash Screen
        let splashScreenVC = SplashScreenViewController()

        // Embed it in a Navigation Controller
        let navigationController = UINavigationController(rootViewController: splashScreenVC)
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // No updates needed
    }
}

