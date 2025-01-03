import SwiftUI

// MARK: - GPTResponseView
struct GPTResponseView: View {
    // Patient and EEG file info
    let patient: SamplePatient
    let file: EEGFile

    // MARK: - State

    /// Stores the parsed TSV result (once fetched & parsed).
    @State private var predictionResult: PredictionResult? = nil

    /// The text returned from GPT.
    @State private var gptReport: String = "Waiting for GPT report..."

    /// Whether we are currently loading (either reading TSV or calling GPT).
    @State private var isLoading: Bool = false

    /// If something goes wrong (e.g., network/file read error), store the error message here.
    @State private var errorMessage: String? = nil

    // MARK: - Dependencies

    /// Your service that handles talking to OpenAI.
    private let aiService = AIService()

    // MARK: - Body

    var body: some View {
        NavigationView {
            ZStack {
                // Subtle Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.systemGroupedBackground),
                        Color.blue.opacity(0.15)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)

                VStack(spacing: 24) {
                    // Title
                    Text("Surgical Outcome")
                        .font(.largeTitle.weight(.bold))
                        .foregroundColor(.primary)
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                        .padding(.top, 16)

                    // Patient + EEG info in a card
                    patientInfoCard()

                    // If there's an error, show it
                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }

                    // Prediction Data (from TSV) in a card
                    predictionCard()

                    // GPT output area
                    gptReportCard()

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("GPT Response")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                // Optionally auto-fetch the TSV upon appearing
                fetchAndParseTSV()
            }
        }
    }

    // MARK: - Subviews

    /// Card showing the patient's basic info.
    @ViewBuilder
    private func patientInfoCard() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                ProfileImageView(username: patient.username)
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())
                    .padding(.trailing, 8)

                VStack(alignment: .leading, spacing: 4) {
                    Text("\(patient.name) \(patient.surname)")
                        .font(Fonts.primary(size: 18, weight: .bold))
                        .foregroundColor(Colors.textPrimary)

                    Text("\(patient.age) | \(patient.gender)")
                        .font(Fonts.body)
                        .foregroundColor(Colors.textSecondary)
                }
                Spacer()
            }

            Divider().padding(.vertical, 4)

            Text("EEG File: \(file.name)")
                .font(Fonts.body)
                .foregroundColor(Colors.textPrimary)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground).opacity(0.9))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 16)
    }

    /// Card that shows the parsed TSV data (predicted label, probabilities) or a fetch button if not yet parsed.
    @ViewBuilder
    private func predictionCard() -> some View {
        VStack(spacing: 16) {
            Text("TSV Prediction Data")
                .font(.headline)

            if isLoading {
                ProgressView("Loading TSV...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(.vertical, 20)
            } else if let prediction = predictionResult {
                VStack(spacing: 8) {
                    infoRow(label: "Predicted Label", value: prediction.predictedLabel)
                    infoRow(label: "Probability F", value: String(format: "%.4f", prediction.probabilityF))
                    infoRow(label: "Probability S", value: String(format: "%.4f", prediction.probabilityS))
                }
            } else {
                Text("No TSV data found yet.")
                    .foregroundColor(.secondary)
            }

            HStack {
                Button(action: {
                    fetchAndParseTSV()
                }) {
                    Text("Fetch TSV")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .disabled(isLoading)

                Button(action: {
                    generateSurgeryGPTReport()
                }) {
                    Text("Send to GPT")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .disabled(predictionResult == nil || isLoading)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground).opacity(0.9))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 16)
    }

    /// Card that displays the GPT-generated report.
    @ViewBuilder
    private func gptReportCard() -> some View {
        VStack(spacing: 16) {
            Text("GPT Generated Report")
                .font(.headline)

            if isLoading {
                ProgressView("Generating report...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(.vertical, 20)
            } else {
                ScrollView {
                    Text(gptReport)
                        .font(.body)
                        .foregroundColor(Colors.textPrimary)
                        .multilineTextAlignment(.leading)
                        .padding()
                }
                .frame(height: 200)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
                .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
            }
        }
        .padding(.horizontal, 16)
    }

    /// Reusable row styling for label-value pairs.
    @ViewBuilder
    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text("\(label):")
                .font(.headline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.headline)
                .foregroundColor(.primary)
        }
    }
}

// MARK: - TSV Fetch & Parse

extension GPTResponseView {
    /// Fetches the TSV file from your server and then parses it.
    /// This example shows how to do POST /run-script with X-Mode=READ_TSV.
    private func fetchAndParseTSV() {
        isLoading = true
        errorMessage = nil
        predictionResult = nil

        guard let url = URL(string: ServerConfig.constructURL(for: "/run-script")) else {
            self.errorMessage = "Invalid server URL."
            self.isLoading = false
            return
        }

        // Build a POST request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Important: set headers so the server knows which .eeg file and patient
        request.setValue(file.name, forHTTPHeaderField: "X-File-Name")
        request.setValue(patient.username, forHTTPHeaderField: "X-Patient-Username")

        // This "READ_TSV" is the special mode your server checks for:
        // if mode_str.upper() == "READ_TSV" => handle_read_tsv(...).
        request.setValue("READ_TSV", forHTTPHeaderField: "X-Mode")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Could not fetch TSV: \(error.localizedDescription)"
                    self.isLoading = false
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "TSV fetch error: invalid server response."
                    self.isLoading = false
                }
                return
            }

            // Convert data to a string
            guard let tsvString = String(data: data, encoding: .utf8) else {
                DispatchQueue.main.async {
                    self.errorMessage = "Could not decode TSV data as UTF-8."
                    self.isLoading = false
                }
                return
            }

            // Parse the TSV
            self.parseTSV(tsvString)
        }
        .resume()
    }

    /// Parses the TSV text, extracts predicted label & probabilities, updates `predictionResult`.
    private func parseTSV(_ tsvString: String) {
        // Split lines, ignoring empties
        let lines = tsvString.components(separatedBy: .newlines).filter { !$0.isEmpty }

        guard lines.count >= 2 else {
            DispatchQueue.main.async {
                self.errorMessage = "TSV file appears empty or incomplete."
                self.isLoading = false
            }
            return
        }

        // Assume first line is header (e.g. "Predicted Label\tProbability F\tProbability S")
        // The second line is data (e.g. "S\t0.4936\t0.5064")
        let dataLine = lines[1]
        let columns = dataLine.components(separatedBy: "\t")

        guard columns.count >= 3 else {
            DispatchQueue.main.async {
                self.errorMessage = "TSV columns are missing."
                self.isLoading = false
            }
            return
        }

        let predictedLabel = columns[0]
        let probabilityF = Double(columns[1]) ?? 0.0
        let probabilityS = Double(columns[2]) ?? 0.0

        let prediction = PredictionResult(
            predictedLabel: predictedLabel,
            probabilityF: probabilityF,
            probabilityS: probabilityS
        )

        DispatchQueue.main.async {
            self.predictionResult = prediction
            self.isLoading = false
        }
    }
}

// MARK: - GPT Logic

extension GPTResponseView {
    /// Builds a prompt using the real data from `predictionResult`.
    private func buildSurgeryPrompt(from result: PredictionResult) -> String {
        let heatmapPath = "ftp-dir/\(patient.username)/heatmap_sub-jh102_ses-presurgery_task-ictal_acq-ecog_run-03_ieeg.png"

        // Instruct GPT to be concise, scientific, from a surgeon's perspective,
        // and to not use asterisks for bold text.
        return """
        You are a surgeon providing a concise yet scientifically oriented summary.
        Do not use asterisks for bold.

        Patient:
        \(patient.name) \(patient.surname), \(patient.age) y/o, \(patient.gender).

        EEG File:
        \(file.name)

        Heatmap (for reference):
        \(heatmapPath)

        Inference Results:
        Predicted Label: \(result.predictedLabel)
        Probability F: \(String(format: "%.4f", result.probabilityF))
        Probability S: \(String(format: "%.4f", result.probabilityS))

        The label "\(result.predictedLabel)" indicates a likely surgical outcome if flagged channels are removed.

        Please discuss:
        1. How the heatmap might guide surgical resection decisions.
        2. How the numeric probabilities factor into expected outcomes.
        3. Key considerations given the patient's scenario.

        Speak from a surgeon's perspective and keep the response relatively brief.
        """
    }

    /// Sends the prompt to GPT using `AIService`, updates the `gptReport`.
    private func generateSurgeryGPTReport() {
        guard let prediction = predictionResult else {
            errorMessage = "No TSV data. Please fetch TSV first."
            return
        }

        isLoading = true
        gptReport = "Awaiting GPT response..."
        errorMessage = nil

        Task {
            let prompt = buildSurgeryPrompt(from: prediction)
            let response = await aiService.getAIResponse(prompt: prompt)

            await MainActor.run {
                gptReport = response
                isLoading = false
            }
        }
    }
}

// MARK: - PREVIEW

struct GPTResponseView_Previews: PreviewProvider {
    static var previews: some View {
        let mockPatient = SamplePatient(
            id: "",
            name: "Jane",
            surname: "Doe",
            age: "30",
            gender: "female",
            username: "janedoe"
        )
        let mockFile = EEGFile(id: UUID(), name: "example.eeg", path: "/path/to/example.eeg")

        GPTResponseView(patient: mockPatient, file: mockFile)
    }
}
