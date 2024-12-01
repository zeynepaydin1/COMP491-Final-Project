//
//  AddPatientView.swift
//  SeizureXpert
//
//  Created by Zeynep Aydın on 11/21/24.
//

import SwiftUI

struct AddPatientView: View {
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var age: String = ""
    @State private var gender: String = "Male" // Default gender

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer().frame(height: 20)

                // Title
                Text("Add Patient")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)

                // Profile Icon
                Image(systemName: "person.crop.circle.badge.plus")
                    .resizable()
                    .frame(width: 120, height: 100)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)

                // Input Fields
                VStack(alignment: .leading, spacing: 5) {
                    TextField("Name", text: $name)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(65)
                        .overlay(
                            RoundedRectangle(cornerRadius: 65)
                                .stroke(name.isEmpty ? Color.gray.opacity(0.4) : Color.gray, lineWidth: 1)
                        )

                    TextField("Surname", text: $surname)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(65)
                        .overlay(
                            RoundedRectangle(cornerRadius: 65)
                                .stroke(surname.isEmpty ? Color.gray.opacity(0.4) : Color.gray, lineWidth: 1)
                        )

                    TextField("Age", text: $age)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(65)
                        .overlay(
                            RoundedRectangle(cornerRadius: 65)
                                .stroke(age.isEmpty ? Color.gray.opacity(0.4) : Color.gray, lineWidth: 1)
                        )

                    // Gender Selection
                    HStack {
                        Text("Sex:")
                            .font(.subheadline)
                            .foregroundColor(.black)

                        Spacer()

                        Picker(selection: $gender, label: Text("Gender")) {
                            Text("Male").tag("Male")
                            Text("Female").tag("Female")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 200)
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal)

                // Add Patient Button
                Button(action: {
                    // Add patient logic goes here
                }) {
                    Text("Add Patient")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)

                Spacer()
            }
            .background(Color.white.ignoresSafeArea())
            .navigationBarHidden(false)
        }
    }
}

// Preview for AddPatientView
#Preview {
    AddPatientView()
}
