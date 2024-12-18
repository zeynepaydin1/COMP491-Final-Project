import Foundation
import FirebaseAuth
import FirebaseFirestore
import UIKit

class SignUpViewModel: ObservableObject {
    @Published var error: String? // Error message to display
    @Published var signupSuccessful = false // Flag to trigger navigation to LoginView

    private let auth = Auth.auth() // Firebase Auth instance
    private let db = Firestore.firestore() // Firestore instance

    func signUp(email: String, password: String, username: String, isDoctor: Bool, name: String, profileImage: UIImage?) {
        // Reset error and signup status
        self.error = nil
        self.signupSuccessful = false

        // Upload profile picture first
        uploadProfilePicture(username: username, profileImage: profileImage) { [weak self] uploadResult in
            guard let self = self else { return }

            switch uploadResult {
            case .success:
                // Proceed with user creation in Firebase Auth
                self.createFirebaseUser(email: email, password: password, username: username, isDoctor: isDoctor, name: name)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.error = "Profile picture upload failed: \(error.localizedDescription)"
                }
            }
        }
    }

    private func uploadProfilePicture(username: String, profileImage: UIImage?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let profileImage = profileImage,
              let imageData = profileImage.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid or missing image."])))
            return
        }

        // Create a unique path for the user's profile picture
        let fileName = "\(username)/profile_picture.jpg" // Folder and file name
        let fullURL = ServerConfig.constructURL(for: fileName) // Use ServerConfig to construct URL

        guard let url = URL(string: fullURL) else {
            completion(.failure(NSError(domain: "URLConstructionError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL constructed."])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(fileName, forHTTPHeaderField: "X-File-Name") // Include folder in the header
        request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        request.httpBody = imageData

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                let uploadError = NSError(domain: "UploadError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to upload profile picture."])
                completion(.failure(uploadError))
                return
            }

            completion(.success(()))
        }.resume()
    }

    private func createFirebaseUser(email: String, password: String, username: String, isDoctor: Bool, name: String) {
        auth.createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }

            if let error = error {
                DispatchQueue.main.async {
                    self.error = "Sign-up failed: \(error.localizedDescription)"
                }
                return
            }

            // If user creation is successful, save user details in Firestore
            if let userId = authResult?.user.uid {
                self.saveUserToDatabase(userId: userId, email: email, username: username, isDoctor: isDoctor, name: name)
            } else {
                DispatchQueue.main.async {
                    self.error = "Unexpected error occurred during sign-up."
                }
            }
        }
    }

    private func saveUserToDatabase(userId: String, email: String, username: String, isDoctor: Bool, name: String) {
        let userData: [String: Any] = [
            "username": username,
            "email": email,
            "isDoctor": isDoctor,
            "name": name
        ]

        db.collection("users").document(userId).setData(userData) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.error = "Failed to save user data: \(error.localizedDescription)"
                } else {
                    self?.signupSuccessful = true
                }
            }
        }
    }
}
