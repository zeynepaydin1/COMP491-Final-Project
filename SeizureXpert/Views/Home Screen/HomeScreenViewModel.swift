import SwiftUI

class HomeScreenViewModel: ObservableObject {
    @Published var proceedingAnalyses: [SamplePatient] = []
    @Published var completedAnalyses: [SamplePatient] = []
    @Published var currentDestination: Destination? // Used for navigation
    @Published var selectedPatient: SamplePatient? // Used for passing data to the visualization page

    init() {
        fetchPatients()
    }

    private func fetchPatients() {
        // Example data
        let allPatients = [
            SamplePatient(name: "John Doe", gender: "male", progress: 0.8),
            SamplePatient(name: "Jane Smith", gender: "female", progress: 1.0),
            SamplePatient(name: "Emily Davis", gender: "female", progress: 0.5),
            SamplePatient(name: "Michael Brown", gender: "male", progress: 1.0)
        ]
        proceedingAnalyses = allPatients.filter { $0.progress < 1.0 }
        completedAnalyses = allPatients.filter { $0.progress == 1.0 }
    }

    func navigateTo(_ destination: Destination) {
        currentDestination = destination
        print("Navigating to \(destination.description)")
    }

    enum Destination: Hashable, CustomStringConvertible {
        case profile
        case notifications
        case settings
        case myPatients
        case allPatients
        case visualization

        var description: String {
            switch self {
            case .profile: return "Profile Page"
            case .notifications: return "Notifications Page"
            case .settings: return "Settings Page"
            case .myPatients: return "My Patients Page"
            case .allPatients: return "All Patients Page"
            case .visualization: return "Visualization Page"
            }
        }
    }
}
