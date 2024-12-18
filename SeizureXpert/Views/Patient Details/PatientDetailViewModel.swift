//
//  PatientDetailViewModel.swift
//  SeizureXpert
//
//  Created by Sarp Vulaş on 22.11.2024.
//

import Foundation
import SwiftUI

class PatientDetailViewModel: ObservableObject {
    @Published var name: String = "Sarp"
    @Published var surname: String = "Vulaş"
    @Published var age: String = "23"
    @Published var gender: String = "Male" // Already pre-selected and not editable.
    @Published var isUploadingEEG: Bool = false
    @Published var isVisualizingSOZ: Bool = false

    func uploadEEGData() {
        // Placeholder function for EEG Data upload
        print("EEG Data upload initiated.")
    }

    func visualizeSOZs() {
        // Placeholder function for SOZ visualization
        print("Visualizing SOZs.")
    }
}
