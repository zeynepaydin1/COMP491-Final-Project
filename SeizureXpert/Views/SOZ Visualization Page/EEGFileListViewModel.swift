//
//  EEGFileListViewModel.swift
//  SeizureXpert
//
//  Created by Sarp Vulaş on 28.12.2024.
//

import Foundation
import SwiftUI

class EEGFileListViewModel: ObservableObject {
    @Published var eegFiles: [EEGFile] = []
    @Published var isLoading: Bool = true
    @Published var fetchError: String? = nil
    @Published var isSendingCommand: Bool = false
    @Published var commandError: String? = nil

    var patient: SamplePatient

    init(patient: SamplePatient) {
        self.patient = patient
        fetchEEGFiles()
    }

    // MARK: - Fetch EEG Files

    /// Fetch the list of EEG files for the patient from the server
    func fetchEEGFiles() {
        let eegFilesURL = ServerConfig.constructURL(for: "\(patient.username)/")
        print("Fetching .eeg files for patient \(patient.username) from URL: \(eegFilesURL)")

        guard let url = URL(string: eegFilesURL) else {
            print("Invalid URL for .eeg files.")
            handleFetchError("Invalid server URL.")
            return
        }

        isLoading = true
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching .eeg files: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.handleFetchError(error.localizedDescription)
                }
                return
            }

            guard let data = data else {
                print("No data received from server.")
                DispatchQueue.main.async {
                    self.handleFetchError("No data received.")
                }
                return
            }

            if let responseData = String(data: data, encoding: .utf8) {
                print("Raw server response: \(responseData)")
                let eegFileNames = self.parseHTMLForEEGFiles(html: responseData)
                DispatchQueue.main.async {
                    if eegFileNames.isEmpty {
                        self.handleFetchError("No .eeg files found.")
                    } else {
                        self.eegFiles = eegFileNames.map {
                            EEGFile(id: UUID(), name: $0, path: ServerConfig.constructURL(for: "\(self.patient.username)/\($0)"))
                        }
                        self.isLoading = false
                    }
                }
            }
        }.resume()
    }

    /// Parse HTML to extract .eeg filenames
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

    /// Handle fetch error
    private func handleFetchError(_ message: String) {
        fetchError = message
        isLoading = false
    }

    // MARK: - Send Commands

    /// Send a command to the server for the selected EEG file with the given mode
    func sendCommand(for file: EEGFile, mode: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: ServerConfig.constructURL(for: "/run-script")) else {
            print("Invalid server URL for \(mode) command.")
            DispatchQueue.main.async {
                self.handleCommandError("Invalid server URL.")
                completion(false)
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(file.name, forHTTPHeaderField: "X-File-Name")
        request.setValue(patient.username, forHTTPHeaderField: "X-Patient-Username")
        request.setValue(mode, forHTTPHeaderField: "X-Mode")

        isSendingCommand = true
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isSendingCommand = false
            }

            if let error = error {
                print("Error sending \(mode) command: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.handleCommandError("Error: \(error.localizedDescription)")
                    completion(false)
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response from server.")
                DispatchQueue.main.async {
                    self.handleCommandError("Invalid response from server.")
                    completion(false)
                }
                return
            }

            if httpResponse.statusCode == 200 {
                print("\(mode.capitalized) command executed successfully.")
                DispatchQueue.main.async {
                    completion(true)
                }
            } else {
                let responseMessage = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
                print("\(mode.capitalized) command failed with status code \(httpResponse.statusCode): \(responseMessage)")
                DispatchQueue.main.async {
                    self.handleCommandError("\(mode.capitalized) command failed: \(responseMessage)")
                    completion(false)
                }
            }
        }.resume()
    }

    /// Wrapper for sending a heatmap command
    func sendHeatmapCommand(for file: EEGFile, completion: @escaping (Bool) -> Void) {
        sendCommand(for: file, mode: "heatmap", completion: completion)
    }

    /// Wrapper for sending a raw EEG visualization command
    func sendRawEEGCommand(for file: EEGFile, completion: @escaping (Bool) -> Void) {
        sendCommand(for: file, mode: "raw", completion: completion)
    }

    /// Handle command error
    private func handleCommandError(_ message: String) {
        commandError = message
    }
}
