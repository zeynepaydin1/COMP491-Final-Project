//
//  AnalysisCell.swift
//  SeizureXpert
//
//  Created by B50 on 30.11.2024.
//

import UIKit

class AnalysisCell: UITableViewCell {
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let progressBar = UIProgressView(progressViewStyle: .default)
    private let progressLabel = UILabel()
    private let infoButton = UIButton()
    private let visualizeButton = UIButton()

    var onInfoButtonTapped: (() -> Void)?
    var onVisualizeButtonTapped: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.backgroundColor = Colors.background
        contentView.layer.cornerRadius = Dimensions.CornerRadius.medium
        contentView.layer.masksToBounds = true

        // Profile Image
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = Dimensions.CornerRadius.large
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false

        // Name Label
        nameLabel.font = Fonts.primary(size: 16, weight: .bold)
        nameLabel.textColor = Colors.textPrimary
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        // Progress Bar
        progressBar.progressTintColor = Colors.progressBarFill
        progressBar.trackTintColor = Colors.progressBarTrack
        progressBar.layer.cornerRadius = Dimensions.CornerRadius.small
        progressBar.clipsToBounds = true
        progressBar.translatesAutoresizingMaskIntoConstraints = false

        // Progress Label
        progressLabel.font = Fonts.caption
        progressLabel.textColor = Colors.textSecondary
        progressLabel.translatesAutoresizingMaskIntoConstraints = false

        // Info Button
        infoButton.setTitle("Info", for: .normal)
        infoButton.backgroundColor = Colors.primary
        infoButton.setTitleColor(.white, for: .normal)
        infoButton.layer.cornerRadius = Dimensions.CornerRadius.small
        infoButton.titleLabel?.font = Fonts.body
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)

        // Visualize Button
        visualizeButton.setTitle("Visualize", for: .normal)
        visualizeButton.backgroundColor = Colors.secondary
        visualizeButton.setTitleColor(.white, for: .normal)
        visualizeButton.layer.cornerRadius = Dimensions.CornerRadius.small
        visualizeButton.titleLabel?.font = Fonts.body
        visualizeButton.translatesAutoresizingMaskIntoConstraints = false
        visualizeButton.addTarget(self, action: #selector(visualizeButtonTapped), for: .touchUpInside)

        // Add Subviews
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(progressBar)
        contentView.addSubview(progressLabel)
        contentView.addSubview(infoButton)
        contentView.addSubview(visualizeButton)

        // Layout Constraints
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Dimensions.Spacing.medium),
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),

            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: Dimensions.Spacing.medium),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Dimensions.Spacing.medium),

            progressBar.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: infoButton.leadingAnchor, constant: -Dimensions.Spacing.small),
            progressBar.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Dimensions.Spacing.small),
            progressBar.heightAnchor.constraint(equalToConstant: 8),

            progressLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            progressLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: Dimensions.Spacing.small),

            infoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Dimensions.Spacing.medium),
            infoButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Dimensions.Spacing.medium),
            infoButton.widthAnchor.constraint(equalToConstant: 80),
            infoButton.heightAnchor.constraint(equalToConstant: 30),

            visualizeButton.trailingAnchor.constraint(equalTo: infoButton.trailingAnchor),
            visualizeButton.topAnchor.constraint(equalTo: infoButton.bottomAnchor, constant: Dimensions.Spacing.small),
            visualizeButton.widthAnchor.constraint(equalTo: infoButton.widthAnchor),
            visualizeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    @objc private func infoButtonTapped() {
        onInfoButtonTapped?()
    }

    @objc private func visualizeButtonTapped() {
        onVisualizeButtonTapped?()
    }

    func configure(with name: String, profileImage: UIImage?, progress: Float) {
        nameLabel.text = name
        profileImageView.image = profileImage
        progressBar.progress = progress
        progressLabel.text = "\(Int(progress * 100))%"

        if progress < 1.0 {
            visualizeButton.isEnabled = false
            visualizeButton.backgroundColor = Colors.progressBarTrack
        } else {
            visualizeButton.isEnabled = true
            visualizeButton.backgroundColor = Colors.progressBarFill
        }
    }
}
