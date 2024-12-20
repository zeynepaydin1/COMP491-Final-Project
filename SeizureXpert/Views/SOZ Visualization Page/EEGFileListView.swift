import SwiftUI
import Foundation

struct EEGFileListView: View {
    var patient: SamplePatient
    var onSelect: (EEGFile) -> Void

    @State private var eegFiles: [EEGFile] = []
    @State private var isLoading: Bool = true
    @State private var fetchError: String? = nil
    @State private var isSendingCommand: Bool = false
    @State private var commandError: String? = nil

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading .eeg files...")
                    .padding()
            } else if let error = fetchError {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else if eegFiles.isEmpty {
                Text("No .eeg files found.")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(eegFiles) { file in
                    Button(action: {
                        isSendingCommand = true
                        sendHeatmapCommand(for: file) { success in
                            isSendingCommand = false
                            if success {
                                onSelect(file)
                            } else {
                                commandError = "Failed to send heatmap creation command."
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "waveform.path")
                                .foregroundColor(.blue)
                            Text(file.name)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                }
                if let commandError = commandError {
                    Text("Error: \(commandError)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
        }
        .navigationTitle("Select EEG File for \(patient.name)")
        .onAppear(perform: fetchEEGFiles)
        .padding()
    }

    private func fetchEEGFiles() {
        let eegFilesURL = ServerConfig.constructURL(for: "\(patient.username)/")
        print("Fetching .eeg files for patient \(patient.username) from URL: \(eegFilesURL)")

        guard let url = URL(string: eegFilesURL) else {
            print("Invalid URL for .eeg files.")
            fetchError = "Invalid server URL."
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching .eeg files: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.fetchError = error.localizedDescription
                    self.isLoading = false
                }
                return
            }

            guard let data = data else {
                print("No data received from server.")
                DispatchQueue.main.async {
                    self.fetchError = "No data received."
                    self.isLoading = false
                }
                return
            }

            if let responseData = String(data: data, encoding: .utf8) {
                print("Raw server response: \(responseData)")
                let eegFileNames = self.parseHTMLForEEGFiles(html: responseData)
                DispatchQueue.main.async {
                    if eegFileNames.isEmpty {
                        self.fetchError = "No .eeg files found."
                    } else {
                        self.eegFiles = eegFileNames.map {
                            EEGFile(id: UUID(), name: $0, path: ServerConfig.constructURL(for: "\(patient.username)/\($0)"))
                        }
                    }
                    self.isLoading = false
                }
            }
        }.resume()
    }


    private func parseHTMLForEEGFiles(html: String) -> [String] {
        var fileNames: [String] = []
        let pattern = #"href=\"([^\"]+\.eeg)\""#
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let matches = regex.matches(in: html, options: [], range: NSRange(html.startIndex..., in: html))
            for match in matches {
                if let range = Range(match.range(at: 1), in: html) {
                    let fileName = String(html[range])
                    fileNames.append(fileName)
                }
            }
        } catch {
            print("Error parsing HTML: \(error.localizedDescription)")
        }
        return fileNames
    }

    private func sendHeatmapCommand(for file: EEGFile, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: ServerConfig.constructURL(for: "/run-script")) else {
            print("Invalid server URL for heatmap command.")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(file.name, forHTTPHeaderField: "X-File-Name") // Pass the .eeg filename
        request.setValue(patient.username, forHTTPHeaderField: "X-Patient-Username") // Pass the username

        // No body needed as per server's expectations
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending heatmap command: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response from server.")
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }

            if httpResponse.statusCode == 200 {
                print("Heatmap command executed successfully.")
                DispatchQueue.main.async {
                    completion(true)
                }
            } else {
                let responseMessage = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
                print("Heatmap command failed with status code \(httpResponse.statusCode): \(responseMessage)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }.resume()
    }

}

struct EEGFileListView_Previews: PreviewProvider {
    static var previews: some View {
        let mockPatient = SamplePatient(
            id: "123",
            name: "Jane",
            surname: "Doe",
            age: "30",
            gender: "Female",
            username: "sarpvulas"
        )
        EEGFileListView(patient: mockPatient, onSelect: { _ in })
    }
}
