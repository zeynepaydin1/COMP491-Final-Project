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
    @State private var image: UIImage?
    @State private var isUsingSystemImage: Bool = false

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "brain.head.profile") // Fallback system image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50) // Set the desired size
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            fetchProfileImage(for: username)
        }
    }

    private func fetchProfileImage(for username: String) {
        let profileImageURL = ServerConfig.constructURL(for: "\(username)/profile_picture.jpg")
        guard let url = URL(string: profileImageURL) else {
            useFallbackImage()
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching profile image for \(username): \(error.localizedDescription)")
                useFallbackImage()
                return
            }

            guard let data = data, let fetchedImage = UIImage(data: data) else {
                print("Failed to decode profile image for \(username).")
                useFallbackImage()
                return
            }

            DispatchQueue.main.async {
                self.image = fetchedImage
                self.isUsingSystemImage = false
            }
        }.resume()
    }

    private func useFallbackImage() {
        DispatchQueue.main.async {
            self.image = nil
            self.isUsingSystemImage = true
        }
    }
}
