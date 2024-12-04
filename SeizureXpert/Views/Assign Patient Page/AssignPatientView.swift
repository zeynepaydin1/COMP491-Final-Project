//
//  AssignPatientView.swift
//  SeizureXpert
//
//  Created by Zeynep Aydın on 12/4/24.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AssignPatientView: View {
    @StateObject private var viewModel = AssignPatientViewModel()
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        VStack {
            Text("Select a Patient to Assign")
                .font(.title2)
                .padding()

            if viewModel.patients.isEmpty {
                Text("No patients available.")
                    .foregroundColor(.gray)
            } else {
                List(viewModel.patients) { patient in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(patient.name) \(patient.surname)")
                                .font(.headline)
                            Text("Age: \(patient.age), Gender: \(patient.gender)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Button("Assign") {
                            viewModel.assignPatient(patient: patient) { success in
                                if success {
                                    presentationMode.wrappedValue.dismiss()
                                } else {
                                    print("Failed to assign patient.")
                                }
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchUnassignedPatients()
        }
    }
}
