//
//  Visualize2DView.swift
//  SeizureXpert
//
//  Created by Sarp Vulaş on 19.12.2024.
//

import SwiftUI

struct Visualize2DView: View {
    let file: EEGFile // The selected EEG file

    var body: some View {
        VStack {
            Text("Visualizing 2D Seizure Onset Zones")
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
    Visualize2DView(file: EEGFile(id: UUID(), name: "example.eeg", path: "/path/to/example.eeg"))
}
