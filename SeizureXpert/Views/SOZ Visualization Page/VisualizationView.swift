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

                // Visualization Grid (3 Rows x 2 Columns with Unique Navigation)
                VStack(spacing: 32) {
                    HStack(spacing: 32) {
                        NavigationLink(
                            destination: EEGFileListViewWrapper(patient: patient) { file in
                                Visualize2DView(file: file)
                            }
                        ) {
                            Text("Visualise 2D Seizure Onset Zones")
                                .font(.headline)
                                .foregroundColor(Colors.primary)
                                .frame(width: 100, height: 100)
                                .padding()
                                .background(.white)
                                .cornerRadius(8)
                                .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 4)
                        }
                        NavigationLink(
                            destination: EEGFileListViewWrapper(patient: patient) { file in
                                Visualize3DView(file: file)
                            }
                        ) {
                            Text("Visualise 3D Seizure Onset Zones")
                                .font(.headline)
                                .foregroundColor(Colors.primary)
                                .frame(width: 100, height: 100)
                                .padding()
                                .background(.white)
                                .cornerRadius(8)
                                .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 4)
                        }
                    }

                    HStack(spacing: 32) {
                        NavigationLink(
                            destination: EEGFileListViewWrapper(patient: patient) { file in
                                HeatmapView(patient: patient, file: file)
                            }
                        ) {
                            Text("Generate Heatmap")
                                .font(.headline)
                                .foregroundColor(Colors.primary)
                                .frame(width: 100, height: 100)
                                .padding()
                                .background(.white)
                                .cornerRadius(8)
                                .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 4)
                        }
                        NavigationLink(
                            destination: EEGFileListViewWrapper(patient: patient) { file in
                                DisplayRawEEGView(file: file)
                            }
                        ) {
                            Text("Display Raw EEG Frequency")
                                .font(.headline)
                                .foregroundColor(Colors.primary)
                                .frame(width: 100, height: 100)
                                .padding()
                                .background(.white)
                                .cornerRadius(8)
                                .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 4)
                        }
                    }

                    HStack(spacing: 32) {
                        NavigationLink(
                            destination: EEGFileListViewWrapper(patient: patient) { file in
                                GPTResponseView(patient: patient, file: file)
                            }
                        ) {
                            Text("Generate GPT Report")
                                .font(.headline)
                                .foregroundColor(Colors.primary)
                                .frame(width: 100, height: 100)
                                .padding()
                                .background(.white)
                                .cornerRadius(8)
                                .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 4)
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
}


// MARK: - EEGFileListViewWrapper
struct EEGFileListViewWrapper<Destination: View>: View {
    let patient: SamplePatient
    let destination: (EEGFile) -> Destination

    @State private var selectedFile: EEGFile?
    @State private var showDetail = false

    var body: some View {
        VStack {
            EEGFileListView(patient: patient) { file in
                // When a file is selected, record it and trigger navigation
                self.selectedFile = file
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
            username: "janedoe" // Sample patient data
        )

        VisualizationView(patient: mockPatient)
            .previewDisplayName("Visualization View")
    }
}
