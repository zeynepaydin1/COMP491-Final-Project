import FirebaseFirestore
import FirebaseAuth

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
                        gender: data["gender"] as? String ?? ""
                    )
                } ?? []

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
            "userId": userId,
            "name": patient.name,
            "surname": patient.surname,
            "age": patient.age,
            "gender": patient.gender
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
