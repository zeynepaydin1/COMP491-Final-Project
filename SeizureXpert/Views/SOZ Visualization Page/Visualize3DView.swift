//
//  Visualize3DView.swift
//  SeizureXpert
//
//  Created by Sarp Vulaş on 19.12.2024.
//

import SwiftUI

struct Visualize3DView: View {
    let file: EEGFile // The selected EEG file

    var body: some View {
        VStack {
            Text("Visualizing 3D Seizure Onset Zones")
                .font(.headline)
                .padding()
            Text("File: \(file.name)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

// MARK: - Preview
#Preview {
    Visualize3DView(file: EEGFile(id: UUID(), name: "example.eeg", path: "/path/to/example.eeg"))
}
