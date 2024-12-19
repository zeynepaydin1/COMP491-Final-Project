//
//  SettingsViewModel.swift
//  SeizureXpert
//
//  Created by Zeynep Aydın on 12/19/24.
//

import Foundation
import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var selectedImage: UIImage? = nil
    @Published var isUploading: Bool = false
    @Published var uploadProgress: Double = 0.0
    @Published var successMessage: String? = nil
    @Published var errorMessage: String? = nil
    @Published var showImagePicker: Bool = false

    func uploadProfileImage(for username: String) {
        guard let image = selectedImage else {
            errorMessage = "No image selected."
            return
        }

        resetMessages()
        isUploading = true

        // Convert image to Data
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            errorMessage = "Failed to process image."
            isUploading = false
            return
        }

        let destinationPath = "\(username)/profile_picture.jpg"

        uploadFile(to: destinationPath, fileData: imageData) { [weak self] result in
            DispatchQueue.main.async {
                self?.isUploading = false
                switch result {
                case .success:
                    self?.successMessage = "Profile picture updated successfully!"
                case .failure(let error):
                    self?.errorMessage = "Upload failed: \(error.localizedDescription)"
                }
            }
        }
    }

    private func uploadFile(to path: String, fileData: Data, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let serverURL = URL(string: ServerConfig.baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: serverURL)
        request.httpMethod = "POST"
        request.addValue(path, forHTTPHeaderField: "X-File-Name")
        request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")

        URLSession.shared.uploadTask(with: request, from: fileData) { [weak self] _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                let uploadError = NSError(
                    domain: "UploadError",
                    code: -2,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to upload file."]
                )
                completion(.failure(uploadError))
                return
            }

            self?.simulateUploadProgress() // Simulate progress update
            completion(.success(()))
        }.resume()
    }

    private func simulateUploadProgress() {
        DispatchQueue.global().async { [weak self] in
            for i in 0...100 {
                usleep(50000) // Simulate a delay
                DispatchQueue.main.async {
                    self?.uploadProgress = Double(i) / 100.0
                }
            }
        }
    }

    private func resetMessages() {
        successMessage = nil
        errorMessage = nil
    }
}
