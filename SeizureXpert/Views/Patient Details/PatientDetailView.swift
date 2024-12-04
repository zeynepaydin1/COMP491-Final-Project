//
//  PatientDetailView.swift
//  SeizureXpert
//
//  Created by Sarp Vulaş on 22.11.2024.
//
import SwiftUI

struct PatientDetailView: View {
    var patient: SamplePatient // Accept a SamplePatient object
    @ObservedObject var viewModel = PatientDetailViewModel()

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
                    // Main Content of Patient Details
                    ScrollView {
                        // Title
                        Text("Patient Details")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .padding(.bottom, 10)

                        // Profile Image
                        Image(systemName: "brain.head.profile")
                            .resizable()
                            .frame(width: 125, height: 125)
                            .clipShape(Circle()) // Optional: Make it circular
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 3) // Optional: Add a border
                            )
                            .shadow(radius: 10)
                            .padding(.bottom, 10)

                        // Information Fields
                        VStack(spacing: 20) {
                            // Name Field
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Name")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Text(patient.name)
                                    .padding(10)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(20)
                            }

                            // Gender Field
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Gender")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Text(patient.gender.capitalized)
                                    .padding(10)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(20)
                            }

                            // Progress Field
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Progress")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Text("\(Int(patient.progress * 100))%")
                                    .padding(10)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(20)
                            }
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
                            // Upload EEG Data Button
                            Button(action: {
                                print("Upload EEG Data for \(patient.name)")
                            }) {
                                Text("Upload EEG Data")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(width: 300, height: 40) // Set button size
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }

                            // Visualize SOZs Button
                            Button(action: {
                                print("Visualize SOZs for \(patient.name)")
                            }) {
                                Text("Visualize SOZs")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(width: 300, height: 40) // Set button size
                                    .background(Color.blue)
                                    .cornerRadius(10)
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

            // Placeholder Tab
            Text("Other Tab Content")
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
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
            progress: 0.75
        )
        PatientDetailView(patient: samplePatient)
    }
}
