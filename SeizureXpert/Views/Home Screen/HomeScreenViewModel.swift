import FirebaseFirestore
import FirebaseAuth

class HomeScreenViewModel: ObservableObject {
    @Published var completedAnalyses: [SamplePatient] = []
    @Published var currentDestination: Destination? // Used for navigation
    @Published var selectedPatient: SamplePatient? // Used for passing data to the visualization page

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration? // For real-time updates

    init() {
        listenToPatients() // Start listening to Firestore changes
    }

    deinit {
        // Stop listening when the view model is deallocated
        listener?.remove()
    }

    func listenToPatients() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: User not authenticated.")
            return
        }

        // Listen for real-time changes in the `patients` collection
        listener = db.collection("patients")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { [weak self] (snapshot, error) in
                guard let self = self else { return }

                if let error = error {
                    print("Error listening to patients: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No patients found for user ID \(userId).")
                    return
                }

                // Map Firestore documents to SamplePatient objects
                let allPatients = documents.compactMap { doc -> SamplePatient? in
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

                // Update the completedAnalyses array with real-time data
                DispatchQueue.main.async {
                    self.completedAnalyses = allPatients
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
        case patientDetail // Add this case for navigating to PatientDetailView

        var description: String {
            switch self {
            case .profile: return "Profile Page"
            case .notifications: return "Notifications Page"
            case .settings: return "Settings Page"
            case .myPatients: return "My Patients Page"
            case .allPatients: return "All Patients Page"
            case .visualization: return "Visualization Page"
            case .patientDetail: return "Patient Detail Page"
            }
        }
    }

}
