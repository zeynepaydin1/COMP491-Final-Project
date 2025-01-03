import SwiftUI

// MARK: - EEGFile Model
struct EEGFile: Identifiable {
    let id: UUID
    let name: String
    let path: String
}

// MARK: - Visualization View
struct VisualizationView: View {
    let patient: SamplePatient

    var body: some View {
        NavigationView {
            VStack {
                // Patient Profile Information
                HStack {
                    ProfileImageView(username: patient.username)
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Colors.primary, lineWidth: 2))
                        .shadow(radius: 5)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(patient.name + " " + patient.surname)
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .foregroundColor(Colors.textPrimary)
                        Text(patient.age + " | " + patient.gender)
                            .font(.system(size: 16, design: .rounded))
                            .foregroundColor(Colors.textSecondary)
                    }
                    Spacer()
                }
                .padding()
                .background(Colors.background.opacity(0.1))
                .cornerRadius(10)
                .shadow(color: .gray.opacity(0.2), radius: 8, x: 0, y: 4)

                Divider()
                    .background(Colors.primary.opacity(0.5))

                // Visualization Grid (2 Rows with Unique Navigation)
                VStack(spacing: 24) {
                    HStack(spacing: 24) {
                        NavigationButton(title: "Generate Heatmap", icon: "flame.fill") {
                            EEGFileListViewWrapper(patient: patient, mode: "heatmap") { file in
                                HeatmapView(patient: patient, file: file)
                            }
                        }
                        NavigationButton(title: "Display Raw EEG Data", icon: "waveform.path.ecg") {
                            EEGFileListViewWrapper(patient: patient, mode: "raw") { file in
                                DisplayRawEEGView(patient: patient, file: file)
                            }
                        }
                    }

                    HStack(spacing: 24) {
                        NavigationButton(title: "Generate GPT Report", icon: "doc.text.fill") {
                            EEGFileListViewWrapper(patient: patient, mode: nil) { file in
                                GPTResponseView(patient: patient, file: file)
                            }
                        }
                        NavigationButton(title: "Predict Surgery Outcome", icon: "heart.fill") {
                            EEGFileListViewWrapper(patient: patient, mode: "prediction") { file in
                                ChannelListView(viewModel: ChannelListViewModel(patient: patient, file: file))
                            }
                        }
                    }
                }
                .padding()

                Spacer()
            }
            .padding()
            .background(Colors.background.ignoresSafeArea())
        }
    }

    private func getChannelsForFile(file: EEGFile) -> [String] {
        // Mock implementation for fetching channel names for a given file
        return ["Channel 1", "Channel 2", "Channel 3", "Channel 4"]
    }
}

// MARK: - Custom Navigation Button
struct NavigationButton<Destination: View>: View {
    let title: String
    let icon: String
    let destination: () -> Destination

    var body: some View {
        NavigationLink(destination: destination()) {
            VStack {
                ZStack {
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Colors.primary.opacity(0.8), Colors.secondary.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 80, height: 80)
                        .shadow(color: .gray.opacity(0.3), radius: 8, x: 0, y: 4)
                    Image(systemName: icon)
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .padding(.top, 8)
                    .foregroundColor(Colors.textPrimary)
                    .shadow(color: Colors.primary.opacity(0.2), radius: 2, x: 0, y: 2)
            }
            .frame(width: 140, height: 140)
            .background(Colors.background.opacity(0.2))
            .cornerRadius(20)
            .shadow(color: .gray.opacity(0.3), radius: 8, x: 0, y: 4)
        }
    }
}

// MARK: - EEGFileListViewWrapper
struct EEGFileListViewWrapper<Destination: View>: View {
    let patient: SamplePatient
    let mode: String?
    let destination: (EEGFile) -> Destination

    @State private var selectedFile: EEGFile?
    @State private var showDetail = false

    var body: some View {
        VStack {
            // Pass mode to EEGFileListView
            EEGFileListView(viewModel: EEGFileListViewModel(patient: patient),
                            mode: mode) { file in
                // When a file is selected, navigate
                self.selectedFile = file

                // If mode is not nil, you can still optionally do something else here,
                // but for the "prediction" mode we skip the script call:
                if let mode = mode, mode != "prediction" {
                    sendCommand(for: file, mode: mode)
                }

                // Then, trigger the detail navigation
                self.showDetail = true
            }

            NavigationLink(
                destination: Group {
                    if let selectedFile = selectedFile {
                        destination(selectedFile)
                    } else {
                        EmptyView()
                    }
                },
                isActive: $showDetail
            ) {
                EmptyView()
            }
        }
    }

    /// Send a command to the server for the selected EEG file
    private func sendCommand(for file: EEGFile, mode: String) {
        let viewModel = EEGFileListViewModel(patient: patient)
        viewModel.sendCommand(for: file, mode: mode) { success in
            if success {
                print("\(mode.capitalized) command executed successfully.")
            } else {
                print("Failed to execute \(mode.capitalized) command.")
            }
        }
    }
}


// MARK: - Preview
struct VisualizationView_Previews: PreviewProvider {
    static var previews: some View {
        let mockPatient = SamplePatient(
            id: "",
            name: "Jane",
            surname: "Doe",
            age: "30",
            gender: "female",
            username: "sarpvulas" // Sample patient data
        )

        VisualizationView(patient: mockPatient)
            .previewDisplayName("Visualization View")
    }
}
