import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

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
                        profileImageURL: data["profileImageURL"] as? String ?? "" // Extract profileImageURL
                    )
                } ?? []

                completion(patients)
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
                        profileImageURL: data["profileImageURL"] as? String ?? ""
                    )
                } ?? []

                completion(patients)
            }
    }

    /// Adds a new patient to Firestore
    static func addPatient(_ patient: SamplePatient, profileImageData: Data? = nil, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()

        var newPatient: [String: Any] = [
            "userId": "",
            "name": patient.name,
            "surname": patient.surname,
            "age": patient.age,
            "gender": patient.gender,
            "profileImageURL": "" // Placeholder for profile image URL
        ]

        // If no profile image, save patient directly
        guard let profileImageData = profileImageData else {
            print("No profile image provided. Adding patient without image.")
            db.collection("patients").addDocument(data: newPatient) { error in
                if let error = error {
                    print("Error adding patient: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("Patient added successfully without profile image.")
                    completion(true)
                }
            }
            return
        }

        // Upload profile image to Firebase Storage
        let storageRef = Storage.storage().reference().child("profile_images/\(UUID().uuidString).jpg")
        print("Starting image upload for patient \(patient.name)...")

        storageRef.putData(profileImageData, metadata: nil) { _, error in
            if let error = error {
                print("Error uploading profile image: \(error.localizedDescription)")
                completion(false)
                return
            }

            // Fetch the download URL
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error retrieving profile image URL: \(error.localizedDescription)")
                    completion(false)
                    return
                }

                guard let url = url else {
                    print("Profile image URL is nil.")
                    completion(false)
                    return
                }

                // Update the newPatient dictionary with the profile image URL
                newPatient["profileImageURL"] = url.absoluteString
                print("Profile image URL retrieved: \(url.absoluteString)")

                // Write the patient data to Firestore
                db.collection("patients").addDocument(data: newPatient) { error in
                    if let error = error {
                        print("Error adding patient with profile image: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("Patient added successfully with profile image.")
                        completion(true)
                    }
                }
            }
        }
    }





    /// Uploads a profile image to Firebase Storage
    static func uploadProfileImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        let storageRef = Storage.storage().reference().child("profile_images/\(UUID().uuidString).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Image"])))
            return
        }

        print("Starting image upload...") // Log
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)") // Log
                completion(.failure(error))
            } else {
                print("Image uploaded successfully: \(String(describing: metadata))") // Log
                storageRef.downloadURL { url, error in
                    if let url = url {
                        print("Image URL retrieved: \(url.absoluteString)") // Log
                        completion(.success(url.absoluteString))
                    } else if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)") // Log
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
