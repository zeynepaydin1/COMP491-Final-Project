import SwiftUI

struct GPTResponseView: View {
    let patient: SamplePatient
    let file: EEGFile // The selected EEG file

    @State private var gptReport: String = "Generating report..."
    @State private var isLoading: Bool = true

    var body: some View {
        NavigationView {
            VStack {
                // Patient Profile Information
                HStack {
                    ProfileImageView(username: patient.username) // Use reusable ProfileImageView
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                    VStack(alignment: .leading, spacing: 4) {
                        Text(patient.name + " " + patient.surname)
                            .font(Fonts.primary(size: 20, weight: .bold))
                            .foregroundColor(Colors.textPrimary)
                        Text(patient.age + " | " + patient.gender)
                            .font(Fonts.body)
                            .foregroundColor(Colors.textSecondary)
                    }
                    Spacer()
                }
                .padding()

                Divider()

                // GPT Report Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Generated GPT Report for File: \(file.name)")
                        .font(.headline)
                        .foregroundColor(Colors.primary)

                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    } else {
                        ScrollView {
                            Text(gptReport)
                                .font(.body)
                                .foregroundColor(Colors.textPrimary)
                                .multilineTextAlignment(.leading)
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                    }

                    Button(action: {
                        regenerateGPTReport()
                    }) {
                        Text("Regenerate Report")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()

                Spacer()
            }
            .padding()
            .background(Colors.background.ignoresSafeArea())
            .navigationBarTitle("Generate GPT Report", displayMode: .inline)
            .onAppear {
                generateGPTReport()
            }
        }
    }

    private func generateGPTReport() {
        isLoading = true
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) { // Simulating network or processing delay
            let generatedText = """
            This is a detailed GPT-generated report for the file \(file.name). It contains valuable insights and observations \
            based on the patient's data and the selected EEG file.
            """
            DispatchQueue.main.async {
                gptReport = generatedText
                isLoading = false
            }
        }
    }

    private func regenerateGPTReport() {
        generateGPTReport()
    }
}

// Preview for GPTResponseView
struct GPTResponseView_Previews: PreviewProvider {
    static var previews: some View {
        let mockPatient = SamplePatient(
            id: "",
            name: "Jane",
            surname: "Doe",
            age: "30",
            gender: "female",
            username: "janedoe" // Sample patient data
        )
        let mockFile = EEGFile(id: UUID(), name: "example.eeg", path: "/path/to/example.eeg")

        GPTResponseView(patient: mockPatient, file: mockFile)
            .previewDisplayName("GPT Response View")
    }
}
