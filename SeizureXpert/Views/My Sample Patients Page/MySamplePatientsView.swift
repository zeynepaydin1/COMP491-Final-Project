import SwiftUI


struct MySamplePatientsView: View {
    @StateObject private var viewModel = MySamplePatientsViewModel()

    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) { // Bind the path to the navigation stack
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
                        NavigationLink(value: patient) { // Navigate to the patient detail view
                            HStack {
                                Image(patient.profileImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                VStack(alignment: .leading) {
                                    Text(patient.name)
                                        .font(Fonts.body)
                                        .foregroundColor(Colors.textPrimary)
                                    Text("Progress: 50%")
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
                    viewModel.navigateToAddPatient() // Call navigation function
                }) {
                    Text("Add New Patient")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Colors.primary)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationDestination(for: SamplePatient.self) { patient in
                PatientDetailView(patient: patient) // Navigate to patient detail view
            }
            .navigationDestination(for: MySamplePatientsViewModel.Destination.self) { destination in
                switch destination {
                case .addPatient:
                    AddPatientView() // No callback needed here
                }
            }
            .onAppear {
                viewModel.fetchMyPatients() // Fetch patients when the view appears
            }
            .background(Colors.background.ignoresSafeArea())
        }
    }
}


struct MySamplePatientsView_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = MySamplePatientsViewModel()

        mockViewModel.myPatients = [
            SamplePatient(id: UUID().uuidString, name: "Jane", surname: "Smith", age: "23", gender: "Female"),
            SamplePatient(id: UUID().uuidString, name: "John", surname: "Doe", age: "23", gender: "Male")
        ]

        return MySamplePatientsView()
            .environmentObject(mockViewModel)
    }
}

