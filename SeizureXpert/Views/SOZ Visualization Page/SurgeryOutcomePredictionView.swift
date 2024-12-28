//
//  SurgeryOutcomePredictionView.swift
//  SeizureXpert
//
//  Created by Sarp Vulaş on 28.12.2024.
//

import SwiftUI

struct SurgeryOutcomePredictionView: View {
    let patient: SamplePatient
    let file: EEGFile

    @State private var isLoading = true
    @State private var executionError: String?
    @State private var predictionResult: String?

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
                        ProgressView("Predicting Outcome...")
                            .padding()

                        Text("Please wait while we analyze the data and predict the surgery outcome.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding()
                } else if let predictionResult = predictionResult {
                    VStack(spacing: 16) {
                        Text("Predicted Surgery Outcome")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)

                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(height: 100)
                                .shadow(color: .gray.opacity(0.3), radius: 8, x: 0, y: 4)

                            Text(predictionResult)
                                .font(.system(size: 24, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                } else {
                    Text("No prediction available.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding()
                }

                Spacer()
            }
        }
        .onAppear {
            runPrediction()
        }
        .navigationTitle("Surgery Outcome")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func runPrediction() {
        // Set the loading state
        isLoading = true
        executionError = nil

        guard let url = URL(string: ServerConfig.constructURL(for: "/predict-surgery-outcome")) else {
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
                    self.executionError = "Failed to predict outcome: \(error.localizedDescription)"
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

            // Parse the prediction result
            if let data = data, let prediction = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.predictionResult = prediction
                    self.isLoading = false
                }
            } else {
                DispatchQueue.main.async {
                    self.executionError = "Invalid prediction response."
                    self.isLoading = false
                }
            }
        }.resume()
    }
}

#Preview {
    let mockPatient = SamplePatient(id: "1", name: "Jane", surname: "Doe", age: "30", gender: "Female", username: "janedoe")
    let mockFile = EEGFile(id: UUID(), name: "mock_file.eeg", path: "/mock/path")

    SurgeryOutcomePredictionView(patient: mockPatient, file: mockFile)
}
