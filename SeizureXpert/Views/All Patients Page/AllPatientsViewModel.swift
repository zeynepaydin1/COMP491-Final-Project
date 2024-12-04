import FirebaseFirestore

class AllPatientsViewModel: ObservableObject {
    @Published var allPatients: [SamplePatient] = []

    func fetchAllPatients() {
        let db = Firestore.firestore()
        db.collection("patients").getDocuments { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching all patients: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else { return }
            DispatchQueue.main.async {
                self?.allPatients = documents.map { doc in
                    let data = doc.data()
                    return SamplePatient(
                        id: doc.documentID,
                        name: data["name"] as? String ?? "",
                        surname: data["surname"] as? String ?? "",
                        age: data["age"] as? String ?? "",
                        gender: data["gender"] as? String ?? "",
                        profileImageURL: data["profileImageURL"] as? String ?? "" // Extract profileImageURL
                    )
                }
            }
        }
    }
}
