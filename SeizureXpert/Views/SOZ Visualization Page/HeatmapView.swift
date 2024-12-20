import SwiftUI

struct HeatmapView: View {
    let patient: SamplePatient
    let file: EEGFile

    @State private var isLoading = true
    @State private var executionError: String?
    @State private var heatmapURL: URL?

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
                        ProgressView("Generating Heatmap...")
                            .padding()

                        Text("Please wait while we process the data and create the heatmap.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding()
                } else if let heatmapURL = heatmapURL {
                    VStack(spacing: 16) {
                        Text("HFO Heatmap")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)

                        AsyncImage(url: heatmapURL) { phase in
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
                    Text("No heatmap available.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding()
                }

                Spacer()
            }
        }
        .onAppear {
            runScriptAndFetchHeatmap()
        }
        .navigationTitle("Heatmap")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func runScriptAndFetchHeatmap() {
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

            // Construct the heatmap URL
            let heatmapPath = "/Users/sarpvulas/ftp-dir/\(patient.username)/heatmap_\(file.name.replacingOccurrences(of: ".eeg", with: ".png"))"
            let localURL = URL(fileURLWithPath: heatmapPath)

            DispatchQueue.main.async {
                self.heatmapURL = localURL
                self.isLoading = false
            }
        }.resume()
    }
}
