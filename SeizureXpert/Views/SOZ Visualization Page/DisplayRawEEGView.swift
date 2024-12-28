//
//  DisplayRawEEGView.swift
//  SeizureXpert
//
//  Created by Sarp Vulaş on 19.12.2024.
//

import SwiftUI

struct DisplayRawEEGView: View {
    let patient: SamplePatient
    let file: EEGFile

    @State private var isLoading = true
    @State private var executionError: String?
    @State private var rawEEGImageURL: URL?

    var body: some View {
        ZStack {
            // Background
            Color(.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                // Header with patient and file details
                VStack(alignment: .leading, spacing: 8) {
                    Text("Patient: \(patient.name) \(patient.surname)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    Text("EEG File: \(file.name)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemBackground))
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                )
                .padding(.horizontal)

                Spacer()

                // Main content area
                if let error = executionError {
                    VStack {
                        Text("Error")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.red)

                        Text(error)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemBackground))
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                    )
                    .padding(.horizontal)
                } else if isLoading {
                    VStack {
                        ProgressView("Generating Raw EEG...")
                            .padding()

                        Text("Please wait while we process the data and create the raw EEG visualization.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding()
                } else if let rawEEGImageURL = rawEEGImageURL {
                    VStack(spacing: 16) {
                        Text("Raw EEG Visualization")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)

                        AsyncImage(url: rawEEGImageURL) { phase in
                            switch phase {
                            case .empty:
                                ProgressView("Loading Image...")
                                    .padding()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                                    .padding(.horizontal)
                            case .failure:
                                Text("Failed to load image.")
                                    .font(.body)
                                    .foregroundColor(.red)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                } else {
                    Text("No raw EEG visualization available.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding()
                }

                Spacer()
            }
        }
        .onAppear {
            runScriptAndFetchRawEEGImage()
        }
        .navigationTitle("Raw EEG")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func runScriptAndFetchRawEEGImage() {
        // Set the loading state
        isLoading = true
        executionError = nil

        guard let url = URL(string: ServerConfig.constructURL(for: "/run-script")) else {
            executionError = "Invalid server URL."
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(file.name, forHTTPHeaderField: "X-File-Name") // Send the selected EEG file
        request.setValue(patient.username, forHTTPHeaderField: "X-Patient-Username") // Send the username
        request.setValue("raw", forHTTPHeaderField: "X-Mode") // Specify the mode as raw EEG visualization

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.executionError = "Failed to execute script: \(error.localizedDescription)"
                    self.isLoading = false
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                let serverError = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
                DispatchQueue.main.async {
                    self.executionError = "Server error: \(serverError)"
                    self.isLoading = false
                }
                return
            }

            // Construct the raw EEG image path
            let rawEEGImagePath = "/Users/sarpvulas/ftp-dir/\(patient.username)/raw_\(file.name.replacingOccurrences(of: ".eeg", with: ".png"))"
            let localURL = URL(fileURLWithPath: rawEEGImagePath)

            DispatchQueue.main.async {
                self.rawEEGImageURL = localURL
                self.isLoading = false
            }
        }.resume()
    }
}

// MARK: - Preview
struct DisplayRawEEGView_Previews: PreviewProvider {
    static var previews: some View {
        let mockFile = EEGFile(id: UUID(), name: "example.eeg", path: "/path/to/example.eeg")
        let mockPatient = SamplePatient(
            id: "",
            name: "Jane",
            surname: "Doe",
            age: "30",
            gender: "female",
            username: "sarpvulas"
        )

        DisplayRawEEGView(patient: mockPatient, file: mockFile)
    }
}
