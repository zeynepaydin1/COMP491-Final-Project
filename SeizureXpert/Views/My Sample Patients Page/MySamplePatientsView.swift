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
                case .addPatient:
                    AddPatientView()
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
        .padding(8)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2, x: 0, y: 2)
    }

    private var addPatientButton: some View {
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
