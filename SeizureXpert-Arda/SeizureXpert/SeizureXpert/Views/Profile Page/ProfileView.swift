//
//  ProfileView.swift
//  SeizureXpert
//
//  Created by B50 on 30.11.2024.
//

import UIKit

class ProfileView: UIView {

    // MARK: - Subviews
    let backButton = UIButton()

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        // Set background color from Design System
        backgroundColor = Colors.background

        // Back Button Configuration
        backButton.setTitle("Back to Home", for: .normal)
        backButton.setTitleColor(Colors.textPrimary, for: .normal) // Design System color
        backButton.backgroundColor = Colors.primary // Design System primary color
        backButton.titleLabel?.font = Fonts.body // Design System font
        backButton.layer.cornerRadius = Dimensions.CornerRadius.medium // Design System corner radius
        backButton.translatesAutoresizingMaskIntoConstraints = false

        // Add Subviews
        addSubview(backButton)

        // Layout Constraints
        NSLayoutConstraint.activate([
            backButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            backButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 200),
            backButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
