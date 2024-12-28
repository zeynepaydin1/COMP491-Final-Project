import SwiftUI

struct ChannelListView: View {
    let patient: SamplePatient
    let file: EEGFile

    @State private var isLoading = true
    @State private var executionError: String?
    @State private var channelNames: [String] = []
    @State private var selectedChannels: Set<String> = []

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                // Header
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
                } else if isLoading {
                    VStack {
                        ProgressView("Loading Channels...")
                            .padding()
                        Text("Please wait while we retrieve and parse the channel file.")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                } else if channelNames.isEmpty {
                    Text("No channels found.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    VStack {
                        // "Select All" and "Deselect All" Buttons
                        HStack(spacing: 16) {
                            Button(action: {
                                selectedChannels = Set(channelNames)
                            }) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.title3)
                                    Text("Select All")
                                        .font(.headline)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue.opacity(0.2))
                                .foregroundColor(.blue)
                                .cornerRadius(12)
                                .shadow(color: Color.blue.opacity(0.3), radius: 3, x: 0, y: 2)
                            }

                            Button(action: {
                                selectedChannels.removeAll()
                            }) {
                                HStack {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title3)
                                    Text("Deselect All")
                                        .font(.headline)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red.opacity(0.2))
                                .foregroundColor(.red)
                                .cornerRadius(12)
                                .shadow(color: Color.red.opacity(0.3), radius: 3, x: 0, y: 2)
                            }
                        }
                        .padding(.horizontal)

                        // Channel List with Multi-Select
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(channelNames, id: \.self) { channel in
                                    HStack {
                                        Image(systemName: selectedChannels.contains(channel) ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(selectedChannels.contains(channel) ? .blue : .gray)
                                            .font(.title3)

                                        Text(channel)
                                            .font(.body)
                                            .foregroundColor(.primary)
                                            .lineLimit(1)
                                            .truncationMode(.tail)

                                        Spacer()
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color(.secondarySystemBackground))
                                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                                    )
                                    .onTapGesture {
                                        toggleSelection(for: channel)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .padding(.top)
        }
        .navigationTitle("Channels")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            runScriptAndFetchChannels()
        }
    }

    /// Toggles the selection of a channel
    private func toggleSelection(for channel: String) {
        if selectedChannels.contains(channel) {
            selectedChannels.remove(channel)
        } else {
            selectedChannels.insert(channel)
        }
    }

    /// Fetch channels and parse them
    private func runScriptAndFetchChannels() {
        isLoading = true
        executionError = nil

        guard let url = URL(string: ServerConfig.constructURL(for: "/run-script")) else {
            self.executionError = "Invalid server URL."
            self.isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(file.name, forHTTPHeaderField: "X-File-Name")
        request.setValue(patient.username, forHTTPHeaderField: "X-Patient-Username")
        request.setValue("channels", forHTTPHeaderField: "X-Mode")  // Request for channels mode

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.executionError = "Failed to execute script: \(error.localizedDescription)"
                    self.isLoading = false
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                  let data = data else {
                let serverError = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
                DispatchQueue.main.async {
                    self.executionError = "Server error: \(serverError)"
                    self.isLoading = false
                }
                return
            }

            // Parse the channels data received from the server
            if let channelsResponse = String(data: data, encoding: .utf8) {
                self.parseTSV(channelsResponse)
            } else {
                DispatchQueue.main.async {
                    self.executionError = "Failed to decode server response."
                    self.isLoading = false
                }
            }
        }
        .resume()
    }

    /// Splits TSV lines, extracts channel names (skipping the header row).
    private func parseTSV(_ tsvString: String) {
        let lines = tsvString.components(separatedBy: .newlines)
        guard lines.count > 1 else {
            DispatchQueue.main.async {
                self.executionError = "TSV file appears empty."
                self.isLoading = false
            }
            return
        }

        // Extract data rows (skip the header line)
        let dataLines = Array(lines.dropFirst())

        var extracted: [String] = []
        for line in dataLines {
            if line.trimmingCharacters(in: .whitespaces).isEmpty { continue }

            let columns = line.components(separatedBy: "\t")
            if let channelName = columns.first {
                extracted.append(channelName)  // Add the first column (channel name)
            }
        }

        DispatchQueue.main.async {
            self.channelNames = extracted
            self.isLoading = false
        }
    }
}
