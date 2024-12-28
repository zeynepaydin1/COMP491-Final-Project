//
//  EEGFileListView.swift
//  SeizureXpert
//
//  Created by Sarp Vulaş on 28.12.2024.
//

import SwiftUI
import Foundation

// MARK: - EEGFileListView
struct EEGFileListView: View {
    @ObservedObject var viewModel: EEGFileListViewModel

    /// Determines how the view behaves:
    /// - `"prediction"`: Skip script execution when an EEG file is tapped
    /// - Otherwise: Call the default script command (e.g., `sendHeatmapCommand`)
    let mode: String?

    /// Closure called when an EEG file is selected.
    /// The parent view will navigate using this callback.
    var onSelect: (EEGFile) -> Void

    var body: some View {
        VStack(spacing: 20) {
            // 1) Loading state
            if viewModel.isLoading {
                VStack {
                    ProgressView()
                        .scaleEffect(1.5, anchor: .center)
                        .padding()
                    Text("Fetching EEG files...")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
            }
            // 2) Error state
            else if let error = viewModel.fetchError {
                VStack(spacing: 10) {
                    Image(systemName: "xmark.octagon")
                        .font(.system(size: 50))
                        .foregroundColor(.red)
                    Text(error)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            // 3) Empty state
            else if viewModel.eegFiles.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "folder.badge.questionmark")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No EEG files found.")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding()
                }
            }
            // 4) Show the list of .eeg files
            else {
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(viewModel.eegFiles) { file in
                            Button(action: {
                                // If mode == "prediction", skip sending any commands
                                if mode == "prediction" {
                                    onSelect(file)
                                } else {
                                    // Default behavior: send a heatmap command
                                    // (Feel free to add more checks for "heatmap", "raw", etc.)
                                    viewModel.isSendingCommand = true
                                    viewModel.sendHeatmapCommand(for: file) { success in
                                        viewModel.isSendingCommand = false
                                        if success {
                                            onSelect(file)
                                        } else {
                                            viewModel.commandError = "Failed to send heatmap creation command."
                                        }
                                    }
                                }
                            }) {
                                HStack(spacing: 15) {
                                    Image(systemName: "waveform.path")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.blue)
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(file.name)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        Text("Tap to generate")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                                .shadow(radius: 3)
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // Display any command error that happened after pressing a file
                if let commandError = viewModel.commandError {
                    Text("Error: \(commandError)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
        }
        .navigationTitle("EEG Files for \(viewModel.patient.name)")
        .padding()
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
}

// MARK: - Preview
struct EEGFileListView_Previews: PreviewProvider {
    static var previews: some View {
        // Mock patient
        let mockPatient = SamplePatient(
            id: "",
            name: "Jane",
            surname: "Doe",
            age: "30",
            gender: "female",
            username: "sarpvulas" // Sample patient data
        )

        // Pass in any mode you like, e.g. "prediction"
        EEGFileListView(
            viewModel: EEGFileListViewModel(patient: mockPatient),
            mode: "prediction"
        ) { selectedFile in
            Text("Selected file: \(selectedFile.name)")
        }
        .previewDisplayName("EEG File List View - Prediction Mode")
    }
}
