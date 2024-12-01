import SwiftUI

struct SamplePatient: Identifiable {
    var id = UUID()
    var name: String
    var gender: String // "male", "female", or other
    var progress: Float

    var profileImage: String {
        switch gender.lowercased() {
        case "male":
            return "male_patient"
        case "female":
            return "female_patient"
        default:
            return "default_profile"
        }
    }
}

