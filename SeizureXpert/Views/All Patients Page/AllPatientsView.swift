import SwiftUI

struct AllPatientsView: View {
    @StateObject private var viewModel = AllPatientsViewModel()

    var body: some View {

        NavigationStack {
            VStack {
                headerView

                if viewModel.allPatients.isEmpty {
                    emptyStateView
                } else {
                    patientsListView
                }
            }
            .onAppear {
                viewModel.fetchAllPatients()
            }
            .background(Colors.background.ignoresSafeArea())
        }
    }

    // MARK: - Subviews

    private var headerView: some View {
        Text("All Patients")
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
        List(viewModel.allPatients) { patient in
            NavigationLink(destination: PatientDetailView(patient: patient)) {
                patientRow(patient)
            }
        }
        .listStyle(PlainListStyle())
    }

    private func patientRow(_ patient: SamplePatient) -> some View {
        HStack {
            // Fetch and display profile image or fallback to default system image
            AsyncImage(url: URL(string: patient.profileImageURL)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                } else if phase.error != nil {
                    // Show fallback system image
                    Image(systemName: patient.systemImageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .foregroundColor(.gray)
                } else {
                    // Placeholder while loading
                    ProgressView()
                        .frame(width: 50, height: 50)
                }
            }

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
}

struct AllPatientsView_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = AllPatientsViewModel()

        mockViewModel.allPatients = [
            SamplePatient(
                id: UUID().uuidString,
                name: "Jane",
                surname: "Smith",
                age: "23",
                gender: "Female",
                username: "jane_smith" // Username for dynamic profileImageURL
            ),
            SamplePatient(
                id: UUID().uuidString,
                name: "John",
                surname: "Doe",
                age: "30",
                gender: "Male",
                username: "john_doe" // Username for dynamic profileImageURL
            )
        ]

        return AllPatientsView()
            .environmentObject(mockViewModel)
    }
}
