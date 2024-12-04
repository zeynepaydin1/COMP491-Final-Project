import SwiftUI

struct MySamplePatientsView: View {
    @StateObject private var viewModel = MySamplePatientsViewModel()

    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            VStack {
                Text("My Patients")
                    .font(Fonts.title)
                    .foregroundColor(Colors.textPrimary)
                    .padding()

                if viewModel.myPatients.isEmpty {
                    Text("No patients available. Add new patients.")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(viewModel.myPatients) { patient in
                        NavigationLink(value: patient) {
                            HStack {
                                if let imageURL = URL(string: patient.profileImageURL) {
                                    AsyncImage(url: imageURL) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 50, height: 50)
                                                .clipShape(Circle())
                                        } else if phase.error != nil {
                                            Image(systemName: "person.crop.circle.badge.exclamationmark")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 50, height: 50)
                                                .clipShape(Circle())
                                                .foregroundColor(.red)
                                        } else {
                                            ProgressView()
                                                .frame(width: 50, height: 50)
                                        }
                                    }
                                } else {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .foregroundColor(.gray)
                                }

                                VStack(alignment: .leading) {
                                    Text(patient.name)
                                        .font(Fonts.body)
                                        .foregroundColor(Colors.textPrimary)
                                    Text(patient.surname)
                                        .font(Fonts.caption)
                                        .foregroundColor(Colors.textSecondary)
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }

                Spacer()

                Button(action: {
                    viewModel.navigationPath.append(MySamplePatientsViewModel.Destination.assignPatient)
                }) {
                    Text("Add New Patient")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Colors.primary)
                        .cornerRadius(10)
                }
                .navigationDestination(for: MySamplePatientsViewModel.Destination.self) { destination in
                    switch destination {
                    case .assignPatient:
                        AssignPatientView() // Navigate to AssignPatientView
                    }
                }
                .padding()
            }
            .navigationDestination(for: SamplePatient.self) { patient in
                PatientDetailView(patient: patient)
            }
            .onAppear {
                viewModel.fetchMyPatients()
            }
            .background(Colors.background.ignoresSafeArea())
        }
    }
}

struct MySamplePatientsView_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = MySamplePatientsViewModel()

        mockViewModel.myPatients = [
            SamplePatient(
                id: UUID().uuidString,
                name: "Jane",
                surname: "Smith",
                age: "23",
                gender: "Female",
                profileImageURL: "https://via.placeholder.com/150" // Example image URL
            ),
            SamplePatient(
                id: UUID().uuidString,
                name: "John",
                surname: "Doe",
                age: "23",
                gender: "Male",
                profileImageURL: "https://via.placeholder.com/150" // Example image URL
            )
        ]

        return MySamplePatientsView()
            .environmentObject(mockViewModel)
    }
}

