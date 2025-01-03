import Foundation
import SwiftUI

// MARK: - ViewModel
class ChannelListViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var executionError: String?
    @Published var channelNames: [String] = []
    @Published var selectedChannels: Set<String> = []
    @Published var isPredicting = false
    @Published var predictionResult: PredictionResult?  // To store the prediction results

    let patient: SamplePatient
    let file: EEGFile

    init(patient: SamplePatient, file: EEGFile) {
        self.patient = patient
        self.file = file
    }

    // MARK: - Toggle Channel Selection
    func toggleSelection(for channel: String) {
        if selectedChannels.contains(channel) {
            selectedChannels.remove(channel)
        } else {
            selectedChannels.insert(channel)
        }
    }

    // MARK: - Select All Channels
    func selectAllChannels() {
        selectedChannels = Set(channelNames)
    }

    // MARK: - Deselect All Channels
    func deselectAllChannels() {
        selectedChannels.removeAll()
    }

    // MARK: - Fetch Channels from Server
    func fetchChannels() {
        isLoading = true
        executionError = nil

        guard let url = URL(string: ServerConfig.constructURL(for: "/run-script")) else {
            updateExecutionError("Invalid server URL.")
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(file.name, forHTTPHeaderField: "X-File-Name")
        request.setValue(patient.username, forHTTPHeaderField: "X-Patient-Username")
        request.setValue("channels", forHTTPHeaderField: "X-Mode")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                self.updateExecutionError("Failed to fetch channels: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                  let data = data else {
                let serverError = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
                self.updateExecutionError("Server error: \(serverError)")
                return
            }

            self.parseChannelsResponse(data)
        }
        .resume()
    }

    private func parseChannelsResponse(_ data: Data) {
        do {
            let channels = try JSONDecoder().decode([String].self, from: data)
            DispatchQueue.main.async {
                self.channelNames = channels
                self.isLoading = false
            }
        } catch {
            self.updateExecutionError("Failed to parse channel response: \(error.localizedDescription)")
        }
    }

    // MARK: - Predict
    func predict() {
        guard !selectedChannels.isEmpty else {
            updateExecutionError("Please select at least one channel to proceed.")
            return
        }

        isPredicting = true
        executionError = nil

        guard let url = URL(string: ServerConfig.constructURL(for: "/run-script")) else {
            updateExecutionError("Invalid server URL.")
            isPredicting = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Construct the dynamic parameters for prediction
        let selectedChannelList = selectedChannels.joined(separator: " ")
        request.setValue(file.name, forHTTPHeaderField: "X-File-Name")
        request.setValue(patient.username, forHTTPHeaderField: "X-Patient-Username")
        request.setValue(selectedChannelList, forHTTPHeaderField: "X-Selected-Channels")
        request.setValue("inference", forHTTPHeaderField: "X-Mode")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                self.updateExecutionError("Prediction failed: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                  let data = data else {
                let serverError = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
                self.updateExecutionError("Server error: \(serverError)")
                return
            }

            self.parsePredictionResults(data)
        }
        .resume()
    }

    // MARK: - Parse Prediction Results
    private func parsePredictionResults(_ data: Data) {
        // Convert raw data to a UTF-8 string
        guard let tsvString = String(data: data, encoding: .utf8) else {
            updateExecutionError("Failed to decode server response.")
            return
        }

        // Split into lines, ignoring any empty ones
        let lines = tsvString.components(separatedBy: .newlines).filter { !$0.isEmpty }
        guard lines.count >= 2 else {
            updateExecutionError("TSV file appears empty or incomplete.")
            return
        }

        // The first line is typically the header row
        let headerLine = lines[0]
        let headers = headerLine.components(separatedBy: "\t")
        // (Optional) If you'd like to do something with 'headers', you can do it here

        // Next lines are data rows; for now, we use the first data row for the result
        let firstDataLine = lines[1]
        let columns = firstDataLine.components(separatedBy: "\t")

        guard columns.count >= 3 else {
            updateExecutionError("TSV file format is incorrect.")
            return
        }

        let predictedLabel = columns[0]
        let probabilityF = Double(columns[1]) ?? 0.0
        let probabilityS = Double(columns[2]) ?? 0.0

        // Update the prediction result on the main thread
        DispatchQueue.main.async {
            self.predictionResult = PredictionResult(
                predictedLabel: predictedLabel,
                probabilityF: probabilityF,
                probabilityS: probabilityS
            )
            self.isPredicting = false
        }
    }

    // MARK: - Error Handling Helper
    private func updateExecutionError(_ message: String) {
        DispatchQueue.main.async {
            self.executionError = message
            self.isLoading = false
            self.isPredicting = false
        }
    }
}

// MARK: - PredictionResult
struct PredictionResult: Equatable {
    let predictedLabel: String
    let probabilityF: Double
    let probabilityS: Double
}
