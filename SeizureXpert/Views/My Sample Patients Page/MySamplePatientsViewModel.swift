import SwiftUI

class MySamplePatientsViewModel: ObservableObject {
    @Published var myPatients: [SamplePatient] = []
    @Published var navigationPath: NavigationPath = NavigationPath() // Manage navigation path

    init() {
        fetchMyPatients()
    }

    func fetchMyPatients() {
        FirestoreUtility.fetchPatientsForCurrentUser { [weak self] patients in
            DispatchQueue.main.async {
                self?.myPatients = patients // Update the state
            }
        }
    }

    func navigateToAddPatient() {
        navigationPath.append(Destination.addPatient)
    }

    func addPatient(_ patient: SamplePatient) {
        FirestoreUtility.addPatient(patient) { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.fetchMyPatients() // Refresh the list after adding
                }
            } else {
                print("Failed to add patient.")
            }
        }
    }

    enum Destination: Hashable {
        case addPatient
    }
}
