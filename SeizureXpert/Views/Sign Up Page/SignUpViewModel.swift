import Foundation
import FirebaseAuth
import FirebaseFirestore
class SignUpViewModel: ObservableObject {
    @Published var error: String?
    @Published var signupSuccessful = false
    let auth = Auth.auth()
    let dbs = Firestore.firestore()
    func signUp(email: String, password: String, username: String, isLecturer: Bool, name: String) {
        self.error = nil
        auth.createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.error = error.localizedDescription
                    self?.signupSuccessful = false
                }
                return
            }
            if let userId = authResult?.user.uid {
                self?.saveUserToDatabase(userId: userId, email: email,
                                         username: username, isLecturer: isLecturer, name: name)
            }
            DispatchQueue.main.async {
                self?.signupSuccessful = true
            }
        }
    }
    private func saveUserToDatabase(userId: String, email: String, username: String, isLecturer: Bool, name: String) {
        self.error = nil
        let ref = dbs.collection("users")
        ref.document(userId).setData([
            "username": username,
            "email": email,
            "isLecturer": isLecturer,
            "name": name
        ]) { [weak self] error in
            if let error = error {
                self?.error = "Failed to save user: \(error.localizedDescription)"
            }
        }
    }
}
