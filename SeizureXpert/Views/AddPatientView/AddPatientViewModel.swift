import Foundation
import FirebaseAuth
import FirebaseFirestore

class AddPatientViewModel: ObservableObject {
    @Published var isAdding: Bool = false
    @Published var error: String?

    func addPatient(name: String, surname: String, age: String, gender: String, progress: Float, completion: @escaping (SamplePatient?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            self.error = "User not authenticated. Cannot add patient."
            completion(nil)
            return
        }

        isAdding = true
        print("Authenticated user ID: \(Auth.auth().currentUser?.uid ?? "No user logged in")")

        let newPatient: [String: Any] = [
            "userId": userId, // Attach the authenticated user's UID
            "name": name,
            "surname": surname,
            "age": age,
            "gender": gender,
            "progress": progress
        ]

        Firestore.firestore().collection("patients").addDocument(data: newPatient) { [weak self] error in
            DispatchQueue.main.async {
                self?.isAdding = false
                if let error = error {
                    self?.error = "Failed to add patient: \(error.localizedDescription)"
                    completion(nil)
                } else {
                    let addedPatient = SamplePatient(
                        id: UUID().uuidString, // Placeholder; use Firestore's document ID if needed
                        name: name,
                        surname: surname,
                        age: age,
                        gender: gender,
                        progress: progress
                    )
                    completion(addedPatient)
                }
            }
        }
    }


    func fetchPatientsForCurrentUser(completion: @escaping ([SamplePatient]) -> Void) {
        // Ensure the user is authenticated
        guard let userId = Auth.auth().currentUser?.uid else {
            self.error = "User not authenticated. Cannot fetch patients."
            completion([])
            return
        }

        // Fetch patients filtered by the logged-in user's ID
        Firestore.firestore().collection("patients")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching patients: \(error.localizedDescription)")
                    completion([])
                    return
                }

                // Map Firestore documents to `SamplePatient` objects
                let patients = snapshot?.documents.compactMap { doc -> SamplePatient? in
                    let data = doc.data()
                    return SamplePatient(
                        id: doc.documentID,
                        name: data["name"] as? String ?? "",
                        surname: data["surname"] as? String ?? "",
                        age: data["age"] as? String ?? "",
                        gender: data["gender"] as? String ?? "",
                        progress: data["progress"] as? Float ?? 0.0
                    )
                } ?? []

                // Return the fetched patients
                completion(patients)
            }
    }
}
