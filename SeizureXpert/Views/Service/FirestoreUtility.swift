import FirebaseFirestore
import FirebaseAuth

class FirestoreUtility {
    /// Fetches patients for the current authenticated user
    static func fetchPatientsForCurrentUser(completion: @escaping ([SamplePatient]) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: User not authenticated.")
            completion([]) // Return an empty array if the user is not authenticated
            return
        }

        let db = Firestore.firestore()
        db.collection("patients")
            .whereField("userId", isEqualTo: userId) // Filter patients by the logged-in user's ID
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching patients: \(error.localizedDescription)")
                    completion([]) // Return an empty array if there was an error
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No patient documents found.")
                    completion([]) // Return an empty array if there are no documents
                    return
                }

                let patients = documents.compactMap { doc -> SamplePatient? in
                    let data = doc.data()
                    return SamplePatient(
                        id: doc.documentID, // Use Firestore's document ID
                        name: data["name"] as? String ?? "",
                        surname: data["surname"] as? String ?? "",
                        age: data["age"] as? String ?? "",
                        gender: data["gender"] as? String ?? "",
                        progress: data["progress"] as? Float ?? 0.0
                    )
                }
                completion(patients)
            }
    }

    /// Adds a new patient to Firestore
    static func addPatient(_ patient: SamplePatient, completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: User not authenticated.")
            completion(false)
            return
        }

        let db = Firestore.firestore()
        let newPatient: [String: Any] = [
            "userId": userId, // Attach the logged-in user's ID
            "name": patient.name,
            "surname": patient.surname,
            "age": patient.age,
            "gender": patient.gender,
            "progress": patient.progress
        ]

        db.collection("patients").addDocument(data: newPatient) { error in
            if let error = error {
                print("Error adding patient: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Patient added successfully.")
                completion(true)
            }
        }
    }

}
