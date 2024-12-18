import FirebaseFirestore
import FirebaseAuth
import UIKit

class FirestoreUtility {
    /// Fetches patients for the current authenticated user
    static func fetchPatientsForCurrentUser(completion: @escaping ([SamplePatient]) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: User not authenticated.")
            completion([])
            return
        }

        let db = Firestore.firestore()
        db.collection("patients")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching patients: \(error.localizedDescription)")
                    completion([])
                    return
                }

                let patients = snapshot?.documents.compactMap { doc -> SamplePatient? in
                    let data = doc.data()
                    return SamplePatient(
                        id: doc.documentID,
                        name: data["name"] as? String ?? "",
                        surname: data["surname"] as? String ?? "",
                        age: data["age"] as? String ?? "",
                        gender: data["gender"] as? String ?? "",
                        username: data["username"] as? String ?? "" // Use username for dynamic profileImageURL
                    )
                } ?? []

                DispatchQueue.main.async {
                    completion(patients)
                }
            }
    }

    /// Fetches unassigned patients from Firestore
    static func fetchUnassignedPatients(completion: @escaping ([SamplePatient]) -> Void) {
        Firestore.firestore().collection("patients")
            .whereField("userId", isEqualTo: "") // Only unassigned patients
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching unassigned patients: \(error.localizedDescription)")
                    completion([])
                    return
                }

                let patients = snapshot?.documents.compactMap { doc -> SamplePatient? in
                    let data = doc.data()
                    return SamplePatient(
                        id: doc.documentID,
                        name: data["name"] as? String ?? "",
                        surname: data["surname"] as? String ?? "",
                        age: data["age"] as? String ?? "",
                        gender: data["gender"] as? String ?? "",
                        username: data["username"] as? String ?? "" // Use username for dynamic profileImageURL
                    )
                } ?? []

                DispatchQueue.main.async {
                    completion(patients)
                }
            }
    }

    /// Adds a new patient to Firestore
    /// Adds a new patient to Firestore
    static func addPatient(_ patient: SamplePatient, profileImage: UIImage?, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()

        // Prepare patient data
        var newPatient: [String: Any] = [
            "userId": "",
            "name": patient.name,
            "surname": patient.surname,
            "age": patient.age,
            "gender": patient.gender,
            "username": patient.username // Store username for dynamic profileImageURL
        ]

        // If no profile image, save patient directly
        guard let profileImage = profileImage,
              let imageData = profileImage.jpegData(compressionQuality: 0.8) else {
            print("No profile image provided. Adding patient without image.")
            db.collection("patients").addDocument(data: newPatient) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error adding patient: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("Patient added successfully without profile image.")
                        completion(true)
                    }
                }
            }
            return
        }

        // Upload profile image to the server
        let profileImagePath = "\(patient.username)/profile_picture.jpg"
        uploadProfileImage(to: profileImagePath, data: imageData) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Profile image uploaded successfully.")
                    db.collection("patients").addDocument(data: newPatient) { error in
                        if let error = error {
                            print("Error adding patient with profile image: \(error.localizedDescription)")
                            completion(false)
                        } else {
                            print("Patient added successfully with profile image.")
                            completion(true)
                        }
                    }
                case .failure(let error):
                    print("Error uploading profile image: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }

    /// Uploads a profile image to the server
    private static func uploadProfileImage(to path: String, data: Data, completion: @escaping (Result<Void, Error>) -> Void) {
        var request = URLRequest(url: URL(string: ServerConfig.baseURL)!)
        request.httpMethod = "POST"
        request.addValue(path, forHTTPHeaderField: "X-File-Name")
        request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        request.httpBody = data

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                let uploadError = NSError(
                    domain: "UploadError",
                    code: -2,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to upload profile image."]
                )
                completion(.failure(uploadError))
                return
            }

            completion(.success(()))
        }.resume()
    }

}
