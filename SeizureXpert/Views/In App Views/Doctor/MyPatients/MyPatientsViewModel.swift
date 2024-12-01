import SwiftUI

struct MyPatientsView: View {
    // Sample patient data
    @State private var patients: [Patient] = [
        Patient(name: "John", surname: "Doe", image: "person.circle.fill", status: .noData),
        Patient(name: "Jane", surname: "Smith", image: "person.circle.fill", status: .processing),
        Patient(name: "Mark", surname: "Johnson", image: "person.circle.fill", status: .visualized),
        Patient(name: "Emily", surname: "Davis", image: "person.circle.fill", status: .visualized)
    ]

    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                // Title and Search Bar
                VStack(spacing: 10) {
                    Text("My Patients")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)

                    HStack {
                        // Search Bar
                        TextField("     Search patients...", text: $searchText)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .overlay(
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                        .padding(.leading, 10)
                                    Spacer()
                                }
                            )

                        // Add Patient Button with NavigationLink
                        NavigationLink(destination: AddPatientView()) {
                            Image(systemName: "person.crop.circle.badge.plus")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 10)

                // Patients List
                ScrollView {
                    ForEach(patients) { patient in
                        HStack(alignment: .top) {
                            // Patient Profile Image
                            Image(systemName: patient.image)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .foregroundColor(.blue)
                                .padding(.trailing, 10)

                            // Patient Details
                            VStack(alignment: .leading, spacing: 5) {
                                Text("\(patient.name) \(patient.surname)")
                                    .font(.headline)
                                    .foregroundColor(.black)

                                // Status Buttons
                                HStack(spacing: 10) {
                                    // EEG Upload Button
                                    Button(action: {
                                        // Upload EEG Data Logic
                                    }) {
                                        Text("Upload EEG Data")
                                            .font(.footnote)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(Color.blue)
                                            .cornerRadius(8)
                                    }

                                    // Placeholder for alignment
                                    HStack {
                                        if patient.status == .noData {
                                            Text("No EEG Data Found")
                                                .font(.footnote)
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 5)
                                                .background(Color.red)
                                                .cornerRadius(8)
                                        } else if patient.status == .processing {
                                            Text("Processing EEG Data")
                                                .font(.footnote)
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 5)
                                                .background(Color.gray)
                                                .cornerRadius(8)
                                        } else if patient.status == .visualized {
                                            Button(action: {
                                                // Visualize SOZ Logic
                                            }) {
                                                Text("Visualize SOZs")
                                                    .font(.footnote)
                                                    .foregroundColor(.white)
                                                    .padding(.horizontal, 10)
                                                    .padding(.vertical, 5)
                                                    .background(Color.green)
                                                    .cornerRadius(8)
                                            }
                                        }
                                    }
                                    .frame(width: 140, alignment: .leading) // Consistent width for alignment
                                }
                            }
                            Spacer()

                            // Info Button
                            Button(action: {
                                // View Patient Details
                            }) {
                                Text("Info")
                                    .font(.footnote)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
            }
            .background(Color.white.ignoresSafeArea())
        }
    }
}

// Model for Patient
struct Patient: Identifiable {
    let id = UUID()
    let name: String
    let surname: String
    let image: String // SF Symbol name
    let status: EEGStatus
}

// EEG Status Enum
enum EEGStatus {
    case noData
    case processing
    case visualized
}

// Preview for MyPatientsView
#Preview {
    MyPatientsView()
}
