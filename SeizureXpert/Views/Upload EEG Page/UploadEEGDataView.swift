//
//  UploadEEGDataView.swift
//  SeizureXpert
//
//  Created by Zeynep Aydın on 12/18/24.
//

import Foundation
import SwiftUI

struct UploadEEGDataView: View {
    let patient: SamplePatient
    @StateObject private var viewModel = UploadEEGDataViewModel()

    var body: some View {
        VStack(spacing: 20) {
            // Patient Information
            HStack {
                ProfileImageView(username: patient.username)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 4) {
                    Text(patient.name + " " + patient.surname)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    Text("\(patient.age) | \(patient.gender.capitalized)")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding()

            Divider()

            // File Picker Button
            Button(action: {
                viewModel.showDocumentPicker = true
            }) {
                Text(viewModel.selectedFileName.isEmpty ? "Select EEG File" : viewModel.selectedFileName)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(50)
            }
            .padding()
            .sheet(isPresented: $viewModel.showDocumentPicker) {
                DocumentPickerView(selectedFileURL: $viewModel.selectedFileURL, selectedFileName: $viewModel.selectedFileName)
            }

            // Progress View
            if viewModel.isUploading {
                VStack {
                    Text("Uploading: \(Int(viewModel.uploadProgress * 100))%")
                        .font(.headline)
                        .padding(.bottom, 10)

                    ProgressView(value: viewModel.uploadProgress)
                        .progressViewStyle(LinearProgressViewStyle())
                        .padding(.horizontal)
                }
            }

            // Success or Error Message
            if let successMessage = viewModel.successMessage {
                Text(successMessage)
                    .foregroundColor(.green)
                    .font(.headline)
                    .padding()
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.headline)
                    .padding()
            }

            // Upload Button
            Button(action: {
                viewModel.uploadEEGFile(for: patient)
            }) {
                Text("Upload File")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(50)
            }
            .padding()
            .disabled(viewModel.selectedFileURL == nil || viewModel.isUploading)

            Spacer()
        }
        .padding()
        .navigationBarTitle("Upload EEG", displayMode: .inline)
    }
}



// Preview
struct UploadEEGDataView_Previews: PreviewProvider {
    static var previews: some View {
        let samplePatient = SamplePatient(
            id: "123",
            name: "John",
            surname: "Doe",
            age: "23",
            gender: "Male",
            username: "john_doe"
        )
        UploadEEGDataView(patient: samplePatient)
    }
}
