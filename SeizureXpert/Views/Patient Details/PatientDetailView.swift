//
//  PatientDetailView.swift
//  SeizureXpert
//
//  Created by Sarp Vulaş on 22.11.2024.
//
import SwiftUI

struct PatientDetailView: View {
    var patient: SamplePatient // Accept a SamplePatient object

    @State private var isVisualizingSOZ: Bool = false // State for navigation to VisualizationView
    @State private var isUploadingEEG: Bool = false // State for navigation to UploadEEGDataView

    var body: some View {
        TabView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.cyan.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack {
                    ScrollView {
                        // Title
                        Text("Patient Details")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .padding(.bottom, 10)

                        // Profile Image using ProfileImageView
                        ProfileImageView(username: patient.username)
                            .frame(width: 125, height: 125)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 3)
                            )
                            .shadow(radius: 10)
                            .padding(.bottom, 10)

                        // Information Fields
                        VStack(spacing: 20) {
                            InfoField(title: "Name", value: patient.name)
                            InfoField(title: "Gender", value: patient.gender.capitalized)
//                            InfoField(title: "Progress", value: "50%")
                            Image(systemName: "waveform.path.ecg") // Default image on error
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .foregroundColor(.gray)
                        }
                        .padding(15)
                        .background(
                            Rectangle()
                                .foregroundColor(.white)
                        )
                        .cornerRadius(15)
                        .shadow(radius: 15)
                        .padding(.horizontal, 15)
                        .padding(.bottom, 15)

                        // Buttons
                        VStack(spacing: 10) {
                            NavigationLink(
                                destination: UploadEEGDataView(patient: patient),
                                isActive: $isUploadingEEG
                            ) {
                                ActionButton(title: "Upload EEG Data") {
                                    isUploadingEEG = true
                                }
                            }

                            NavigationLink(
                                destination: VisualizationView(patient: patient),
                                isActive: $isVisualizingSOZ
                            ) {
                                ActionButton(title: "Visualize SOZs") {
                                    isVisualizingSOZ = true
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .tabItem {
                Image(systemName: "brain.head.profile")
                Text("Patient")
            }
            Text("Other Tab Content")
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
    }
}

// Helper for Info Field
private struct InfoField: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
            Text(value)
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(20)
        }
    }
}

// Helper for Action Button
private struct ActionButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 300, height: 40)
                .background(Color.blue)
                .cornerRadius(10)
        }
    }
}

struct PatientDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let samplePatient = SamplePatient(
            id: "123",
            name: "John",
            surname: "Doe",
            age: "23",
            gender: "Male",
            username: "john_doe" // Add username to dynamically generate profileImageURL
        )
        PatientDetailView(patient: samplePatient)
    }
}
