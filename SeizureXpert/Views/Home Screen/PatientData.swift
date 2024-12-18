import FirebaseFirestore
import UIKit

class PatientData {
    /// Fetch patients for the current user
    static func getPatients(completion: @escaping ([SamplePatient]) -> Void) {
        FirestoreUtility.fetchPatientsForCurrentUser(completion: completion)
    }

    /// Add a new patient with an optional profile image
    static func addPatient(_ patient: SamplePatient, profileImage: UIImage?, completion: @escaping (Bool) -> Void) {
        FirestoreUtility.addPatient(patient, profileImage: profileImage, completion: completion)
    }
}
