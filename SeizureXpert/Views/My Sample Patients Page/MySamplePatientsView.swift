import SwiftUI

struct MySamplePatientsView: View {
    @StateObject private var viewModel = MySamplePatientsViewModel()

    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) { // Use the navigation path
            VStack {
                headerView

                if viewModel.myPatients.isEmpty {
                    emptyStateView
                } else {
                    patientsListView
                }

                Spacer()

                addPatientButton // Add New Patient button
            }
            .navigationDestination(for: MySamplePatientsViewModel.Destination.self) { destination in
                switch destination {
                case .assignPatient:
                    AssignPatientView()
                }
            }
            .onAppear {
                viewModel.fetchMyPatients()
            }
            .background(Colors.background.ignoresSafeArea())
        }
    }

    // MARK: - Subviews

    private var headerView: some View {
        Text("My Patients")
            .font(Fonts.title)
            .foregroundColor(Colors.textPrimary)
            .padding()
    }

    private var emptyStateView: some View {
        Text("No patients available. Please add new patients.")
            .font(Fonts.body)
            .foregroundColor(.gray)
            .padding()
    }

    private var patientsListView: some View {
        List(viewModel.myPatients) { patient in
            NavigationLink(destination: PatientDetailView(patient: patient)) {
                patientRow(patient)
            }
        }
        .listStyle(PlainListStyle())
    }

    private func patientRow(_ patient: SamplePatient) -> some View {
        HStack {
            AsyncImage(url: URL(string: patient.profileImageURL)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                } else if phase.error != nil {
                    Image(systemName: "brain.head.profile") // Default image on error
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .foregroundColor(.gray)
                } else {
                    ProgressView() // Placeholder while loading
                        .frame(width: 50, height: 50)
                }
            }

            VStack(alignment: .leading) {
                Text(patient.name)
                    .font(Fonts.body)
                    .foregroundColor(Colors.textPrimary)

//                Text("Progress: 50%")
//                    .font(Fonts.caption)
//                    .foregroundColor(Colors.textSecondary)
                Image(systemName: "waveform.path.ecg") // Default image on error
                    .resizable()
                    .scaledToFill()
                    .frame(width: 25, height: 25)
                    .clipShape(Circle())
                    .foregroundColor(.gray)
            }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2, x: 0, y: 2)
    }

    private var addPatientButton: some View {
        Button(action: {
            print("Navigating to AssignPatientView") // Debug log
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
        .padding()
    }
}

// MARK: - Preview

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
                username: "jane_smith" // Username used for profile image generation
            ),
            SamplePatient(
                id: UUID().uuidString,
                name: "John",
                surname: "Doe",
                age: "23",
                gender: "Male",
                username: "john_doe" // Username used for profile image generation
            )
        ]

        return MySamplePatientsView()
            .environmentObject(mockViewModel)
    }
}
