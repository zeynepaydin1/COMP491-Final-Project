import SwiftUI

class AllPatientsViewModel: ObservableObject {
    @Published var allPatients: [SamplePatient]

    init() {
        // Fetch all patients in the system
        self.allPatients = PatientData.getPatients()
    }
}
