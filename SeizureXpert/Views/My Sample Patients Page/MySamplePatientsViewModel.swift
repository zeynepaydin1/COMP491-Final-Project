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

    enum Destination: Hashable {
        case assignPatient // Add this case
    }
    
}
