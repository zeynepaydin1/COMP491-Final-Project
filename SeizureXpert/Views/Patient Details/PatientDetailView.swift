//
//  PatientDetailView.swift
//  SeizureXpert
//
//  Created by Sarp Vulaş on 22.11.2024.
//

import SwiftUI

struct PatientDetailView: View {
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
                        VStack {
                            // Name Field
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Name")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .padding(.bottom, 5)
                                TextField("Name", text: $viewModel.name)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(10)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(20)
                                    .disabled(true) // Non-editable
                            }
                            .padding(.horizontal, 5)
                            .padding(.vertical, 5)

                            // Surname Field
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Surname")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .padding(.bottom, 5)
                                TextField("Surname", text: $viewModel.surname)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(10)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(20)
                                    .disabled(true) // Non-editable
                            }
                            .padding(.horizontal, 5)
                            .padding(.vertical, 5)

                            // Age Field
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Age")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .padding(.bottom, 5)
                                TextField("Age", text: $viewModel.age)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(10)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(20)
                                    .disabled(true) // Non-editable
                            }
                            .padding(.horizontal, 5)
                            .padding(.vertical, 5)

                            // Sex Field (Non-selectable)
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Sex")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .padding(.bottom, 5)
                                TextField("Sex", text: $viewModel.sex)
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(20)
                                    .disabled(true)
                            }
                            .padding(.horizontal, 5)
                            .padding(.bottom, 5)
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
                                viewModel.isUploadingEEG = true // Trigger animation
                                viewModel.uploadEEGData()      // Perform the action

                                // Reset the animation state after a slight delay
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    viewModel.isUploadingEEG = false
                                }
                            }) {
                                Text("Upload EEG Data")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(width: 300, height: 40) // Set button size
                                    .background(viewModel.isUploadingEEG ? Color.blue.opacity(0.8) : Color.blue) // Dimming effect
                                    .cornerRadius(10)
                                    .scaleEffect(viewModel.isUploadingEEG ? 0.95 : 1.0) // Press effect
                                    .animation(.easeInOut(duration: 0.2), value: viewModel.isUploadingEEG) // Smooth animation
                            }

                            // Visualize SOZs Button
                            Button(action: {
                                viewModel.isVisualizingSOZ = true // Trigger animation
                                viewModel.visualizeSOZs()        // Perform the action

                                // Reset the animation state after a slight delay
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    viewModel.isVisualizingSOZ = false
                                }
                            }) {
                                Text("Visualize SOZs")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(width: 300, height: 40) // Set button size
                                    .background(viewModel.isVisualizingSOZ ? Color.blue.opacity(0.8) : Color.blue) // Dimming effect
                                    .cornerRadius(10)
                                    .scaleEffect(viewModel.isVisualizingSOZ ? 0.95 : 1.0) // Press effect
                                    .animation(.easeInOut(duration: 0.2), value: viewModel.isVisualizingSOZ) // Smooth animation
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
        PatientDetailView()
    }
}
