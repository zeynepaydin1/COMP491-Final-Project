//
//  AssignPatientViewModel.swift
//  SeizureXpert
//
//  Created by Zeynep Aydın on 12/4/24.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class AssignPatientViewModel: ObservableObject {
    @Published var patients: [SamplePatient] = []
    private let db = Firestore.firestore()

    /// Fetch patients without a doctor assigned
    func fetchUnassignedPatients() {
        db.collection("patients")
            .whereField("userId", isEqualTo: "") // Fetch patients without a doctor assigned
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching unassigned patients: \(error.localizedDescription)")
                    return
                }

                self?.patients = snapshot?.documents.compactMap { doc -> SamplePatient? in
                    let data = doc.data()
                    return SamplePatient(
                        id: doc.documentID,
                        name: data["name"] as? String ?? "",
                        surname: data["surname"] as? String ?? "",
                        age: data["age"] as? String ?? "",
                        gender: data["gender"] as? String ?? "",
                        username: data["username"] as? String ?? "" // Use username for dynamic profileImageURL
                    )
                } ?? []
            }
    }

    /// Assign a patient to the current authenticated user
    func assignPatient(patient: SamplePatient, completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: User not authenticated.")
            completion(false)
            return
        }

        db.collection("patients").document(patient.id).updateData(["userId": userId]) { error in
            if let error = error {
                print("Error assigning patient: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Patient assigned successfully.")
                completion(true)
            }
        }
    }
}
