import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import UIKit

class AddPatientViewModel: ObservableObject {
    @Published var isAdding: Bool = false
    @Published var error: String?

    /// Adds a patient with optional profile image
    func addPatient(patient: SamplePatient, profileImage: UIImage?, completion: @escaping (Bool) -> Void) {
        isAdding = true
        error = nil

        if let profileImage = profileImage {
            let profileImagePath = "\(patient.username)/profile_picture.jpg"

            uploadProfileImage(to: profileImagePath, image: profileImage) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.savePatient(patient, completion: completion)
                    case .failure(let uploadError):
                        self?.isAdding = false
                        self?.error = "Failed to upload profile image: \(uploadError.localizedDescription)"
                        completion(false)
                    }
                }
            }
        } else {
            savePatient(patient, completion: completion)
        }
    }

    /// Saves patient data to Firestore
    private func savePatient(_ patient: SamplePatient, completion: @escaping (Bool) -> Void) {
        FirestoreUtility.addPatient(patient, profileImage: nil) { [weak self] success in
            DispatchQueue.main.async {
                self?.isAdding = false
                if !success {
                    self?.error = "Failed to add patient."
                }
                completion(success)
            }
        }
    }

    /// Uploads a profile image to the server
    private func uploadProfileImage(to path: String, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid or missing image."])))
            return
        }

        var request = URLRequest(url: URL(string: ServerConfig.baseURL)!)
        request.httpMethod = "POST"
        request.addValue(path, forHTTPHeaderField: "X-File-Name")
        request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        request.httpBody = imageData

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NSError(domain: "UploadError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to upload profile image."])))
                return
            }

            completion(.success(()))
        }.resume()
    }
}
