import FirebaseFirestore

class PatientData {
    static func getPatients(completion: @escaping ([SamplePatient]) -> Void) {
        FirestoreUtility.fetchPatientsForCurrentUser(completion: completion)
    }

    static func addPatient(_ patient: SamplePatient, completion: @escaping (Bool) -> Void) {
        FirestoreUtility.addPatient(patient, completion: completion)
    }
}
