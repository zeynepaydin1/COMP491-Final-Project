import Foundation

struct SamplePatient: Identifiable, Hashable {
    var id: String
    var name: String
    var surname: String
    var age: String
    var gender: String // "Male" or "Female"

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

    // Conformance to Hashable
    static func == (lhs: SamplePatient, rhs: SamplePatient) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
