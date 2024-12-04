import Foundation
import FirebaseAuth
import FirebaseFirestore

class AddPatientViewModel: ObservableObject {
    @Published var isAdding: Bool = false
    @Published var error: String?

    func addPatient(patient: SamplePatient, completion: @escaping (Bool) -> Void) {
        isAdding = true
        FirestoreUtility.addPatient(patient) { [weak self] success in
            DispatchQueue.main.async {
                self?.isAdding = false
                if !success {
                    self?.error = "Failed to add patient."
                }
                completion(success)
            }
        }
    }
}
