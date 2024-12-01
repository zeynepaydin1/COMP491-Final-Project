import Foundation
import FirebaseAuth
import FirebaseFirestore

class SignUpViewModel: ObservableObject {
    @Published var error: String? // Error message to display
    @Published var signupSuccessful = false // Flag to trigger navigation to LoginView

    private let auth = Auth.auth() // Firebase Auth instance
    private let db = Firestore.firestore() // Firestore instance

    /// Sign up a new user with email, password, and additional user details.
    func signUp(email: String, password: String, username: String, isDoctor: Bool, name: String) {
        // Reset error and signup status
        self.error = nil
        self.signupSuccessful = false

        // Create a user in Firebase Auth
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

    /// Save additional user details to Firestore.
    private func saveUserToDatabase(userId: String, email: String, username: String, isDoctor: Bool, name: String) {
        let userData: [String: Any] = [
            "username": username,
            "email": email,
            "isDoctor": isDoctor,
            "name": name
        ]

        // Save user data to Firestore under the "users" collection
        db.collection("users").document(userId).setData(userData) { [weak self] error in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if let error = error {
                    self.error = "Failed to save user data: \(error.localizedDescription)"
                } else {
                    // If Firestore save is successful, trigger signup completion
                    self.signupSuccessful = true
                }
            }
        }
    }
}
