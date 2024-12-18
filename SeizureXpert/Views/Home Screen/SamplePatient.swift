import Foundation

struct SamplePatient: Identifiable, Hashable {
    var id: String
    var name: String
    var surname: String
    var age: String
    var gender: String // "Male" or "Female"
    var username: String // Add username to construct the profile picture URL

    /// Computed property to dynamically generate the profile image URL
    var profileImageURL: String {
        return ServerConfig.constructURL(for: "\(username)/profile_picture.jpg")
    }

    /// Property to use a default system image if the profile image does not exist
    var systemImageName: String {
        "brain.head.profile"
    }

    // Conformance to Hashable
    static func == (lhs: SamplePatient, rhs: SamplePatient) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    /// Method to check if the profile picture exists on the server
    func imageExists(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: profileImageURL) else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "HEAD" // Check existence without downloading

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
}
