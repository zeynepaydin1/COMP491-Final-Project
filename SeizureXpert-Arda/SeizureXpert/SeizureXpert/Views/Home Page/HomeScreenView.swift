//
//  HomeScreenView.swift
//  SeizureXpert
//
//  Created by B50 on 30.11.2024.
//

import UIKit

class HomeScreenView: UIView {

    // MARK: - Subviews
    let doctorProfileView = UIView()
    let doctorProfileImageView = UIImageView()
    let doctorNameLabel = UILabel()
    let doctorDetailsLabel = UILabel()
    let notificationButton = UIButton()
    let settingsButton = UIButton()
    let analysisTableView = UITableView()
    let pageSlider = UISegmentedControl(items: ["Home", "My Patients", "All Patients", "Profile"])

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
        backgroundColor = Colors.background

        // Doctor Profile Section
        setupDoctorProfile()

        // Table View
        analysisTableView.register(AnalysisCell.self, forCellReuseIdentifier: "AnalysisCell")
        analysisTableView.translatesAutoresizingMaskIntoConstraints = false
        analysisTableView.backgroundColor = Colors.background

        // Page Slider
        pageSlider.selectedSegmentIndex = 0
        pageSlider.translatesAutoresizingMaskIntoConstraints = false
        pageSlider.backgroundColor = Colors.secondary

        // Add Subviews
        addSubview(doctorProfileView)
        addSubview(analysisTableView)
        addSubview(pageSlider)

        // Layout Constraints
        NSLayoutConstraint.activate([
            // Doctor Profile View
            doctorProfileView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            doctorProfileView.leadingAnchor.constraint(equalTo: leadingAnchor),
            doctorProfileView.trailingAnchor.constraint(equalTo: trailingAnchor),
            doctorProfileView.heightAnchor.constraint(equalToConstant: 100),

            // Table View
            analysisTableView.topAnchor.constraint(equalTo: doctorProfileView.bottomAnchor, constant: Dimensions.Spacing.large),
            analysisTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Dimensions.Spacing.medium),
            analysisTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Dimensions.Spacing.medium),
            analysisTableView.bottomAnchor.constraint(equalTo: pageSlider.topAnchor, constant: -Dimensions.Spacing.large),

            // Page Slider
            pageSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Dimensions.Spacing.medium),
            pageSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Dimensions.Spacing.medium),
            pageSlider.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Dimensions.Spacing.medium)
        ])
    }

    private func setupDoctorProfile() {
        doctorProfileView.translatesAutoresizingMaskIntoConstraints = false

        // Doctor Profile Image
        doctorProfileImageView.image = UIImage(named: "doctor")
        doctorProfileImageView.contentMode = .scaleAspectFill
        doctorProfileImageView.layer.cornerRadius = Dimensions.CornerRadius.large
        doctorProfileImageView.clipsToBounds = true
        doctorProfileImageView.translatesAutoresizingMaskIntoConstraints = false

        // Doctor Name Label
        doctorNameLabel.font = Fonts.title
        doctorNameLabel.textColor = Colors.textPrimary
        doctorNameLabel.text = "Dr. Sarah Lee" // Example placeholder text
        doctorNameLabel.translatesAutoresizingMaskIntoConstraints = false

        // Doctor Details Label
        doctorDetailsLabel.font = Fonts.body
        doctorDetailsLabel.textColor = Colors.textSecondary
        doctorDetailsLabel.text = "Neurologist | EEG Specialist" // Example placeholder text
        doctorDetailsLabel.translatesAutoresizingMaskIntoConstraints = false

        // Notification Button
        notificationButton.setImage(UIImage(systemName: "bell"), for: .normal)
        notificationButton.tintColor = Colors.primary
        notificationButton.translatesAutoresizingMaskIntoConstraints = false

        // Settings Button
        settingsButton.setImage(UIImage(systemName: "gear"), for: .normal)
        settingsButton.tintColor = Colors.primary
        settingsButton.translatesAutoresizingMaskIntoConstraints = false

        // Add Subviews to `doctorProfileView`
        doctorProfileView.addSubview(doctorProfileImageView)
        doctorProfileView.addSubview(doctorNameLabel)
        doctorProfileView.addSubview(doctorDetailsLabel)
        doctorProfileView.addSubview(notificationButton)
        doctorProfileView.addSubview(settingsButton)

        // Layout Constraints
        NSLayoutConstraint.activate([
            // Profile Image
            doctorProfileImageView.leadingAnchor.constraint(equalTo: doctorProfileView.leadingAnchor, constant: Dimensions.Spacing.medium),
            doctorProfileImageView.centerYAnchor.constraint(equalTo: doctorProfileView.centerYAnchor),
            doctorProfileImageView.widthAnchor.constraint(equalToConstant: 80),
            doctorProfileImageView.heightAnchor.constraint(equalToConstant: 80),

            // Name Label
            doctorNameLabel.leadingAnchor.constraint(equalTo: doctorProfileImageView.trailingAnchor, constant: Dimensions.Spacing.medium),
            doctorNameLabel.topAnchor.constraint(equalTo: doctorProfileView.topAnchor, constant: 25),

            // Details Label
            doctorDetailsLabel.leadingAnchor.constraint(equalTo: doctorNameLabel.leadingAnchor),
            doctorDetailsLabel.topAnchor.constraint(equalTo: doctorNameLabel.bottomAnchor, constant: Dimensions.Spacing.small),

            // Notification Button
            notificationButton.trailingAnchor.constraint(equalTo: settingsButton.leadingAnchor, constant: -Dimensions.Spacing.small),
            notificationButton.centerYAnchor.constraint(equalTo: doctorProfileView.centerYAnchor),
            notificationButton.widthAnchor.constraint(equalToConstant: 30),
            notificationButton.heightAnchor.constraint(equalToConstant: 30),

            // Settings Button
            settingsButton.trailingAnchor.constraint(equalTo: doctorProfileView.trailingAnchor, constant: -Dimensions.Spacing.medium),
            settingsButton.centerYAnchor.constraint(equalTo: doctorProfileView.centerYAnchor),
            settingsButton.widthAnchor.constraint(equalToConstant: 30),
            settingsButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

}
