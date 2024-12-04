import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class HomeScreenViewModel: ObservableObject {
    @Published var proceedingAnalyses: [SamplePatient] = []
    @Published var completedAnalyses: [SamplePatient] = []
    @Published var currentDestination: Destination? // Used for navigation
    @Published var selectedPatient: SamplePatient? // Used for passing data to the visualization page

    private let db = Firestore.firestore()

    init() {
        fetchPatients()
    }
    func fetchPatients() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: User not authenticated.")
            return
        }

        db.collection("patients")
            .whereField("userId", isEqualTo: userId) // Ensure you're filtering by the current user
            .getDocuments { [weak self] (snapshot, error) in
                guard let self = self else { return }

                if let error = error {
                    print("Error fetching patients: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No patients found for user ID \(userId).")
                    return
                }

                let allPatients = documents.compactMap { doc -> SamplePatient? in
                    let data = doc.data()
                    return SamplePatient(
                        id: doc.documentID,
                        name: data["name"] as? String ?? "",
                        surname: data["surname"] as? String ?? "",
                        age: data["age"] as? String ?? "",
                        gender: data["gender"] as? String ?? "",
                        progress: data["progress"] as? Float ?? 0.0
                    )
                }

                DispatchQueue.main.async {
                    self.proceedingAnalyses = allPatients.filter { $0.progress < 1.0 }
                    self.completedAnalyses = allPatients.filter { $0.progress == 1.0 }
                }
            }
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
