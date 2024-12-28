import SwiftUI
import Foundation

// MARK: - EEGFileListView
struct EEGFileListView: View {
    @ObservedObject var viewModel: EEGFileListViewModel
    var onSelect: (EEGFile) -> Void

    var body: some View {
        VStack(spacing: 20) {
            if viewModel.isLoading {
                VStack {
                    ProgressView()
                        .scaleEffect(1.5, anchor: .center)
                        .padding()
                    Text("Fetching EEG files...")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
            } else if let error = viewModel.fetchError {
                VStack(spacing: 10) {
                    Image(systemName: "xmark.octagon")
                        .font(.system(size: 50))
                        .foregroundColor(.red)
                    Text(error)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            } else if viewModel.eegFiles.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "folder.badge.questionmark")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No EEG files found.")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding()
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(viewModel.eegFiles) { file in
                            Button(action: {
                                viewModel.isSendingCommand = true
                                viewModel.sendHeatmapCommand(for: file) { success in
                                    viewModel.isSendingCommand = false
                                    if success {
                                        onSelect(file)
                                    } else {
                                        viewModel.commandError = "Failed to send heatmap creation command."
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

// MARK: - VisualizationView_Previews
struct EEGFileListView_Previews: PreviewProvider {
    static var previews: some View {
        let mockPatient = SamplePatient(
            id: "",
            name: "Jane",
            surname: "Doe",
            age: "30",
            gender: "female",
            username: "sarpvulas" // Sample patient data
        )

        EEGFileListView(viewModel: EEGFileListViewModel(patient: mockPatient), onSelect: { selectedFile in
            Text("Selected file: \(selectedFile.name)")
        })
        .previewDisplayName("EEG File List View")
    }
}
