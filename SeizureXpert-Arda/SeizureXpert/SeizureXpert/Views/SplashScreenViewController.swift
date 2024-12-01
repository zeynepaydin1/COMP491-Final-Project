//
//  SplashScreenViewController.swift
//  SeizureXpert
//
//  Created by B50 on 29.11.2024.
//

import Foundation
import UIKit

class SplashScreenViewController: UIViewController {
    private let logoImageView = UIImageView(image: UIImage(named: "LogoBlue")) // Add your logo image to Assets.xcassets
    private let titleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        performSplashAnimation()
    }

    private func setupUI() {
        // Use DesignSystem color
        view.backgroundColor = Colors.primary

        // Configure logo
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)

        // Configure title label
        titleLabel.text = "Seizure Xpert"
        titleLabel.font = Fonts.title
        titleLabel.textColor = Colors.textSecondary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // Add constraints
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),

            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func performSplashAnimation() {
        logoImageView.alpha = 0
        titleLabel.alpha = 0

        UIView.animate(withDuration: 2, animations: {
            self.logoImageView.alpha = 1
            self.titleLabel.alpha = 1
        }) { _ in
            self.transitionToHomeScreen()
        }
    }

    private func transitionToHomeScreen() {
        // Navigate to HomeScreenViewController
        let homeVC = HomeScreenViewController()
        navigationController?.setViewControllers([homeVC], animated: true)
    }
}
