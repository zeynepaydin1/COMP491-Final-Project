import Foundation
import SwiftUI
import FirebaseFirestore

class PatientDetailViewModel: ObservableObject {
    @Published var isUploadingEEG: Bool = false
    @Published var isVisualizingSOZ: Bool = false
    @Published var isUploadingProfileImage: Bool = false // Separate flag for profile image upload
    @Published var profileImage: UIImage? // Holds the updated profile image
    @Published var errorMessage: String? // For error handling
    @Published var successMessage: String? // For success messages

    private let firestoreUtility = FirestoreUtility()

    /// Upload EEG data placeholder function
    func uploadEEGData(for patient: SamplePatient) {
        isUploadingEEG = true
        errorMessage = nil
        successMessage = nil

        // Simulate EEG data upload with a delay
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) { [weak self] in
            DispatchQueue.main.async {
                self?.isUploadingEEG = false
                self?.successMessage = "EEG data uploaded successfully for \(patient.name)."
            }
        }
    }

    /// Visualize Seizure Onset Zones (SOZs) placeholder function
    func visualizeSOZs(for patient: SamplePatient) {
        isVisualizingSOZ = true
        errorMessage = nil
        successMessage = nil

        // Simulate visualization logic
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) { [weak self] in
            DispatchQueue.main.async {
                self?.isVisualizingSOZ = false
                self?.successMessage = "Visualization for \(patient.name) complete."
            }
        }
    }

    /// Update patient profile image URL in Firestore
    func updateProfileImage(for patient: SamplePatient, image: UIImage) {
        // Convert UIImage to Data for upload
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            self.errorMessage = "Failed to process the image."
            return
        }

        isUploadingProfileImage = true
        errorMessage = nil
        successMessage = nil

        // Call FirestoreUtility to upload the image and update profileImageURL
        FirestoreUtility.uploadProfileImage(image) { [weak self] result in
            DispatchQueue.main.async {
                self?.isUploadingProfileImage = false
                switch result {
                case .success(let imageURL):
                    // Update Firestore document with the new profile image URL
                    Firestore.firestore().collection("patients").document(patient.id).updateData([
                        "profileImageURL": imageURL
                    ]) { error in
                        if let error = error {
                            self?.errorMessage = "Failed to update Firestore: \(error.localizedDescription)"
                        } else {
                            self?.successMessage = "Profile image updated successfully."
                            self?.profileImage = image // Update local profile image
                        }
                    }
                case .failure(let error):
                    self?.errorMessage = "Failed to upload profile image: \(error.localizedDescription)"
                }
            }
        }
    }
}
