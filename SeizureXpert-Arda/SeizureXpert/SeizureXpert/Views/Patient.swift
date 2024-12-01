

import UIKit

// Patient Model
struct Patient {
    let name: String
    let profileImage: UIImage?
    let progress: Float
}

// Sample Data
class PatientData {
    static func getPatients() -> [Patient] {
        return [
            Patient(name: "Sam Emanuel", profileImage: UIImage(named: "male_patient"), progress: 0.2),
            Patient(name: "John Doe", profileImage: UIImage(named: "male_patient"), progress: 0.3),
            Patient(name: "Emily Davis", profileImage: UIImage(named: "female_patient"), progress: 0.8),
            Patient(name: "Jane Dove", profileImage: UIImage(named: "female_patient"), progress: 1.0),
            Patient(name: "John Doe", profileImage: UIImage(named: "male_patient"), progress: 0.3),
            Patient(name: "John Doe", profileImage: UIImage(named: "male_patient"), progress: 0.4),
            Patient(name: "John Doe", profileImage: UIImage(named: "male_patient"), progress: 0.7),
            Patient(name: "John Doe", profileImage: UIImage(named: "male_patient"), progress: 0.1)
        ]
    }
}
