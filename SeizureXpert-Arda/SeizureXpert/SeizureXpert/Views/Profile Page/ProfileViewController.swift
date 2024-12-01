//
//  ProfileViewController.swift
//  SeizureXpert
//
//  Created by B50 on 30.11.2024.
//

import UIKit

class ProfileViewController: UIViewController {

    private let profileView = ProfileView()

    override func loadView() {
        view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }

    // MARK: - Setup Actions
    private func setupActions() {
        profileView.backButton.addTarget(self, action: #selector(backToHome), for: .touchUpInside)
    }

    // MARK: - Actions
    @objc private func backToHome() {
        navigationController?.popViewController(animated: true)
    }
}
