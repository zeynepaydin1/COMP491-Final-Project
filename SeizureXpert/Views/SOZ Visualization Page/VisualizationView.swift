import SwiftUI

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
                        NavigationLink(destination: Visualize2DView()) {
                            Text("Visualise 2D Seizure Onset Zones")
                                .font(.headline)
                                .foregroundColor(Colors.primary)
                                .frame(width: 100, height: 100)
                                .padding()
                                .background(.white)
                                .cornerRadius(8)
                                .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 4)
                        }
                        NavigationLink(destination: Visualize3DView()) {
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
                        Button(action: {
                            print("Retrieve High-Frequency Oscillations tapped")
                        }) {
                            Text("Retrieve High-Frequency Oscillations")
                                .font(.headline)
                                .foregroundColor(Colors.primary)
                                .frame(width: 100, height: 100)
                                .padding()
                                .background(.white)
                                .cornerRadius(8)
                                .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 4)
                        }
                        NavigationLink(destination: HeatmapView()) {
                            Text("Generate Heatmap")
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
                        NavigationLink(destination: DisplayRawEEGView()) {
                            Text("Display Raw EEG Frequency")
                                .font(.headline)
                                .foregroundColor(Colors.primary)
                                .frame(width: 100, height: 100)
                                .padding()
                                .background(.white)
                                .cornerRadius(8)
                                .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 4)
                        }
                        NavigationLink(destination: GPTResponseView(patient: patient)) {
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

// Preview for VisualizationView
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
