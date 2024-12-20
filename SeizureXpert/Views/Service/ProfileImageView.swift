//
//  ProfileImageView.swift
//  SeizureXpert
//
//  Created by Zeynep Aydın on 12/18/24.
//

import Foundation
import SwiftUI

struct ProfileImageView: View {
    let username: String
    @State private var image: UIImage? // Store the fetched image
    @State private var isUsingFallbackImage: Bool = false // Track if fallback image is being used

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
            } else if isUsingFallbackImage {
                // Fallback system image
                Image(systemName: "brain.head.profile")
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .foregroundColor(.gray)
                    .frame(width: 50, height: 50) // Set desired size for profile image
            } else {
                // Placeholder while loading
                ProgressView()
                    .frame(width: 50, height: 50)
            }
        }
        .onAppear {
            fetchProfileImage(for: username)
        }
    }

    // MARK: - Fetch Profile Image
    private func fetchProfileImage(for username: String) {
        let profileImageURL = ServerConfig.constructURL(for: "\(username)/profile_picture.jpg")
        print("Fetching profile image from URL: \(profileImageURL)") // Log the URL

        guard let url = URL(string: profileImageURL) else {
            print("Invalid URL for profile image.")
            useFallbackImage()
            return
        }

        // Perform URL session to fetch image
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching profile image for \(username): \(error.localizedDescription)")
                useFallbackImage()
                return
            }

            guard let data = data, let fetchedImage = UIImage(data: data) else {
                print("Failed to decode image data for \(username).")
                useFallbackImage()
                return
            }

            // Update image on the main thread
            DispatchQueue.main.async {
                self.image = fetchedImage
                self.isUsingFallbackImage = false
            }
        }.resume()
    }

    // MARK: - Fallback Image
    private func useFallbackImage() {
        DispatchQueue.main.async {
            self.image = nil
            self.isUsingFallbackImage = true
        }
    }
}
