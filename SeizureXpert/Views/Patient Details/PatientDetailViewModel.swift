//
//  PatientDetailViewModel.swift
//  SeizureXpert
//
//  Created by Sarp Vulaş on 22.11.2024.
//

import Foundation
import SwiftUI

class PatientDetailViewModel: ObservableObject {
    @Published var name: String = "Sarp"
    @Published var surname: String = "Vulaş"
    @Published var age: String = "23"
    @Published var gender: String = "Male" // Already pre-selected and not editable.
    @Published var isUploadingEEG: Bool = false
    @Published var isVisualizingSOZ: Bool = false
    @Published var profileImage: UIImage? // Profile image to be displayed
    @Published var isUsingSystemImage: Bool = false // Flag to indicate fallback to system image

    /// Fetch profile picture or fallback to the default system image
    func fetchProfileImage(for patient: SamplePatient) {
        // Use ServerConfig to construct the URL
        let profileImagePath = "\(patient.username)/profile_picture.jpg"
        let profileImageURL = ServerConfig.constructURL(for: profileImagePath)

        guard let url = URL(string: profileImageURL) else {
            setDefaultImage()
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error fetching profile image: \(error.localizedDescription)")
                self?.setDefaultImage()
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to decode image data.")
                self?.setDefaultImage()
                return
            }

            DispatchQueue.main.async {
                self?.profileImage = image
                self?.isUsingSystemImage = false
            }
        }.resume()
    }

    /// Upload EEG data placeholder function
    func uploadEEGData() {
        print("EEG Data upload initiated.")
    }

    /// Visualize SOZs placeholder function
    func visualizeSOZs() {
        print("Visualizing SOZs.")
    }

    /// Set the default image if fetching fails
    private func setDefaultImage() {
        DispatchQueue.main.async {
            self.profileImage = UIImage(systemName: "brain.head.profile")
            self.isUsingSystemImage = true
        }
    }
}
