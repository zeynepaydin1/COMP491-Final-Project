//
//  DisplayRawEEGView.swift
//  SeizureXpert
//
//  Created by Sarp Vulaş on 19.12.2024.
//

import SwiftUI

struct DisplayRawEEGView: View {
    let file: EEGFile // The selected EEG file

    var body: some View {
        VStack {
            Text("Displaying Raw EEG Data")
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
    DisplayRawEEGView(file: EEGFile(id: UUID(), name: "example.eeg", path: "/path/to/example.eeg"))
}
