import SwiftUI

class MySamplePatientsViewModel: ObservableObject {
    @Published var myPatients: [SamplePatient]

    init() {
        // Filter patients based on assignment logic
        self.myPatients = PatientData.getPatients()
    }
}
